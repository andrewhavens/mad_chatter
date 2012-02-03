var MadChatter = {
	
	init: function(ws_host){
		$('#chat_wrapper').hide();
		MadChatter.init_websocket(ws_host);
		MadChatter.wait_for_join();
	},
	
	init_websocket: function(ws_host){
		if (typeof WebSocket === 'undefined') {
	    	alert("Your browser does not support websockets.")
			return false;
	    }
		var ws =  new WebSocket(ws_host);
		ws.onopen = function(){};
		ws.onclose = function(){
			MadChatter.display_status('You have been disconnected');
			// setTimeout('("MadChatter.reconnect('+ws_host+'")', 10000); //need to figure out how to re-join chat onopen
		};
		ws.onmessage = function(e){
			// console.log(e.data)
			var data = JSON.parse(e.data);
			console.log(data);
			MadChatter.message_received(data);
		};
		MadChatter.ws = ws;
	},
	
	// reconnect: function(){
	// 	console.log('trying to reconnect...');
	// },
	
	wait_for_join: function(){
		$('#pick_a_username').submit(function(e){
			e.preventDefault();
			MadChatter.join_chat();
		});
	},
	
	join_chat: function(){
		var username = $.trim($('#username').val());
		if (username.length == 0) {
			alert('Please enter your name.');
			return false;
		}
		
		MadChatter.send_message('/nick ' + username);
		
		$('#login_screen').hide();
		$('#chat_wrapper').show();
		
		$('.join_room').on('click', function(e){
			e.preventDefault();
			$('#lobby').hide();
			
			var channel_id = $(this).attr('data-id'),
				channel_name = $(this).text();
				
			MadChatter.join_channel(channel_id, channel_name);
		});
		
		$('#channel_tabs a').on('click', function(e){
			e.preventDefault();
			$('#channel_tabs li').removeClass('active');
			var channel_id = $(this).attr('data-id');
			$('.room').hide();
			if (channel_id == 'lobby') {
				$('#lobby').show();
			} else {
				$('.room[data-id="' + channel_id + '"]').show();
			}
		});
	},
	
	join_channel: function(channel_id, channel_name){
		var $existing_channel = $('#channel_tabs a[data-id="' + channel_id + '"]');
		
		if ($existing_channel.length > 0) { //already joined
			$existing_channel.trigger('click');
			return false;
		}
		
		MadChatter.send_message('/join', channel_id);
		$('#channel_tabs li').removeClass('active');
		$('#channel_tabs').append('<li class="active"><a href="#" data-id="' + channel_id + '">' + channel_name + '</a></li>');
		var $room = $('#room_template').clone();
		$room.attr('id','').attr('data-channel', channel_id);
		$room.appendTo('#chat_wrapper').show();
		MadChatter.add_room_actions($room);
	},
	
	add_room_actions: function($room){
		$('.new_message input', $room).keyup(function(e){
			if (e.keyCode == 13) { // The enter key.
				var message = $(this).val(),
					channel = $(this).closest('.room').attr('data-channel');
				if ($.trim(message) != '') {
					MadChatter.send_message(message, channel);
					$(this).val('');
				}
			}
		});
	},
	
	scroll_to_bottom_of_chat: function(){
		// $("body")[0].scrollTop = $("#messages")[0].scrollHeight;
	},
	
	send_message: function(message, channel){
		if (message == '/clear') {
			MadChatter.clear_messages();
		} else {
			var json = {
				token: MadChatter.client_token, 
				message: message,
				channel: channel
			};
			MadChatter.ws.send(JSON.stringify(json));
		}
	},
	
	clear_messages: function(channel){
		$('.room[data-channel="' + channel + '"] .messages').empty();
	},
	
	message_received: function(data){
		data.type, data.channel, data.username, data.text, data.html, data.growl
		if (data.type == 'error') {
			console.log('Client error: ' + data.text)
			return;
		}
		if (data.type == 'token') {
			MadChatter.client_token = data.text;
			return;
		}
		if (data.type == 'channels') {
			MadChatter.update_channels_list(data.json);
			return;
		}
		if (data.type == 'users') {
			MadChatter.update_users_list(data.channel, data.json);
			return;
		}
		if (data.type == 'status') {
			MadChatter.display_status(data.channel, data.text);
		}
		if (data.type == 'action') {
			MadChatter.exec_action(data.channel, data.json);
		}
		if (data.type == 'message') {
			MadChatter.display_message(data.channel, data.username, data.html);
			if (typeof(MadChatterGrowl) != 'undefined') {
				MadChatterGrowl.send_(data.username, data.growl);
			}
		}
		MadChatter.scroll_to_bottom_of_chat();
	},
	
	update_channels_list: function(channels){
		var $list  = $('#channels');
		$list.html('');
		$.each(channels, function(index, channel) {
		  $list.append('<li><a class="join_room" href="#" data-id="' + channel.id + '">' + channel.name + '</a></li>');
		});
	},
		
	update_users_list: function(channel, users){
		var $list  = $('.room[data-channel="' + channel + '"] ul.users');
		$list.html('');
		$.each(users, function(index, username) {
		  $list.append('<li>' + username + '</li>');
		});
	},

	exec_action: function(channel, action){
		window[action.function].apply(window, action.args);
	},
			
	display_status: function(channel, message){
		$('.room[data-channel="' + channel + '"] .messages').append("<p class='status'>" + message + "<time>" + MadChatter.get_current_time() + "</time></p>");
	},
	
	display_message: function(channel, username, message){
		$('.room[data-channel="' + channel + '"] .messages').append("<p class='message'><time>" + MadChatter.get_current_time() + "</time><span class='username'>" + username + ":</span> " + message + "</p>");
	},
	
	get_current_time: function(){
		var time = new Date();
		var hours = time.getHours();
		var minutes = time.getMinutes();
		var ampm = 'am';
		if (hours > 11) { ampm = 'pm'; }
		if (minutes < 10) { minutes = "0" + minutes; }
		if (hours == 0) { hours = 12; }
		if (hours > 12) { hours = hours - 12; }
		return hours + ':' + minutes + ampm;
	}
};
