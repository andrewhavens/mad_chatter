var MadChatter = {
	
	init: function(ws_host){
		$('#chat_wrapper').hide();
		MadChatter.init_websocket(ws_host);
		MadChatter.wait_for_join();
	},
	
	init_websocket: function(ws_host){
		if (typeof WebSocket === 'undefined') {
			return false;
	    }
		var ws =  new WebSocket(ws_host);
		ws.onopen = function(){
			MadChatter.resume_chat();
		};
		ws.onclose = function(){
			MadChatter.token = null;
			MadChatter.reconnect(ws_host);
		};
		ws.onmessage = function(e){
			var data = JSON.parse(e.data);
			// console.log(data);
			MadChatter.message_received(data);
		};
		MadChatter.ws = ws;
	},
	
	reconnect: function(ws_host){
		$('#disconnected').modal('show');
		setTimeout('MadChatter.init_websocket("'+ws_host+'")', 10000);
	},
	
	resume_chat: function(){
		setTimeout(function(){
			$('#disconnected').modal('hide');
			if (MadChatter.token && MadChatter.username) {
				MadChatter.set_username(MadChatter.username);
				$('#channel_tabs li').each(function(){
					var channel = $(this).find('a').attr('data-channel');
					if (channel != 'lobby') {
						MadChatter.send_message('/join', channel);
					}
				});
			}
		}, 2000); //wait two seconds. we should have a token by then
	},
	
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
		
		MadChatter.set_username(username);
		$('#login_screen').hide();
		$('#chat_wrapper').show();
		
		MadChatter.add_channel_tab('lobby', 'Lobby').trigger('click');
		
		$('.navbar .brand').on('click', function(e){
			e.preventDefault();
			MadChatter.join_channel('lobby');
		});
		
		$('#users-nav').popover({
			placement: 'bottom',
			content: function(){
				return $('.channel:visible .users-list').html();
			},
			delay: { show: 0, hide: 1000 }
		});
		
		$('#channels, #channel_tabs').on('click', '.join_channel', function(e){
			e.preventDefault();
			var channel_id = $(this).attr('data-channel'),
				channel_name = $(this).text();
			MadChatter.add_channel_tab(channel_id, channel_name).trigger('click');
		});
		
		$('#share_photo .btn-primary').on('click', function(e){
			e.preventDefault();
			var channel = $('.channel:visible').attr('data-channel'),
				$input = $(this).closest('.modal').find('input[name="url"]'),
				img_url = $input.val();
			if ($.trim(img_url).length > 0) {
				MadChatter.send_message('/img ' + img_url, channel);
				$('#share_photo').modal('hide');
				$input.val('');
			}
		});
		
		$('#share_code .btn-primary').on('click', function(e){
			e.preventDefault();
			var channel = $('.channel:visible').attr('data-channel'),
				$input = $(this).closest('.modal').find('textarea'),
				code = $input.val();
			if ($.trim(code).length > 0) {
				MadChatter.send_message('/code ' + code, channel);
				$('#share_code').modal('hide');
				$input.val('');
			}
		});
		
		$('#create_channel .btn-primary').on('click', function(e){
			e.preventDefault();
			var $input = $(this).closest('.modal').find('input');
			var channel_name = $.trim($input.val());
			if (channel_name.length > 0) {
				MadChatter.send_message('/channel create ' + channel_name);
				$('#create_channel').modal('hide');
				$input.val('');
			}
		});
	},
	
	set_username: function(username){
		MadChatter.username = username;
		MadChatter.send_message('/nick ' + username);
	},
	
	add_channel_tab: function(channel_id, channel_name){
		var $existing_channel_tab = $('#channel_tabs a[data-channel="' + channel_id + '"]');
		if ($existing_channel_tab.length > 0) {
			return $existing_channel_tab;
		}
		
		var $channel_tab = $('<li><a href="#" data-channel="' + channel_id + '">' + channel_name + '</a></li>')
		
		$channel_tab.on('click', function(e){
			e.preventDefault();
			MadChatter.join_channel(channel_id);
		});
		
		$('#channel_tabs').append($channel_tab);
		return $channel_tab;
	},
	
	join_channel: function(channel_id){
		$('#channel_tabs li')
			.removeClass('active')
			.find('a[data-channel="' + channel_id + '"]').parent().addClass('active');
		$('.channel').hide();
		var $channel = $('.channel[data-channel="' + channel_id + '"]');
		if ($channel.length == 0) {
			MadChatter.send_message('/join', channel_id);
			//need to figure out how to wait for response to see if we're allowed to join
			//solution: create .channel, but when server responds, it wont send messages, it will send not-authorized message
			var $channel = $('#channel_template').clone();
			$channel
				.removeAttr('id')
				.attr('data-channel', channel_id)
				.appendTo('#chat_wrapper');
			MadChatter.add_channel_actions($channel);
		}
		if (channel_id == 'lobby') {
			$('#users-nav').hide();
		} else {
			$('#users-nav').show();
		}
		$channel.show();
		MadChatter.scroll_to_bottom_of_chat(channel_id);
	},
	
	add_channel_actions: function($channel){
		
		function send_message($input){
			var message = $input.val(),
				channel = $input.closest('.channel').attr('data-channel');
			if ($.trim(message) != '') {
				MadChatter.send_message(message, channel);
				$input.val('');
			}
		}
		
		$('.new_message input', $channel).keyup(function(e){
			if (e.keyCode == 13) { // The enter key.
				send_message($(this));
			}
		});
		
		$('.new_message .send_message', $channel).on('click', function(e){
			e.preventDefault();
			var $input = $(this).closest('.new_message').find('input');
			send_message($input);
		});
	},
	
	scroll_to_bottom_of_chat: function(channel_id){
		$('body')[0].scrollTop = $(document).height();
	},
	
	send_message: function(message, channel){
		if (message == '/clear') {
			MadChatter.clear_messages(channel);
		} else {
			var json = {
				token: MadChatter.token, 
				message: message,
				channel: channel
			};
			MadChatter.ws.send(JSON.stringify(json));
		}
	},
	
	clear_messages: function(channel){
		$('.channel[data-channel="' + channel + '"] .messages').empty();
	},
	
	message_received: function(data){
		if (data.type == 'error') {
			console.log('Client error: ' + data.text)
			return;
		}
		if (data.type == 'token') {
			MadChatter.token = data.text;
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
			MadChatter.display_status(data.channel, data.text, data.time);
		}
		if (data.type == 'action') {
			MadChatter.exec_action(data.channel, data.json);
		}
		if (data.type == 'message') {
			MadChatter.display_message(data.channel, data.username, data.html, data.time);
			if (typeof(MadChatterGrowl) != 'undefined') {
				MadChatterGrowl.send_(data.username, data.growl);
			}
		}
		MadChatter.scroll_to_bottom_of_chat(data.channel);
	},
	
	update_channels_list: function(channels){
		var $list  = $('#channels');
		$list.html('');
		$.each(channels, function(index, channel) {
		  $list.append('<li><a class="join_channel" href="#" data-channel="' + channel.id + '">' + channel.name + '</a></li>');
		});
	},
		
	update_users_list: function(channel, users){
		var $list  = $('.channel[data-channel="' + channel + '"] ul.users');
		$list.find('li:not(.nav-header)').remove();
		$.each(users, function(index, username) {
		  $list.append('<li><span class="username">' + username + '</span></li>');
		});
	},

	exec_action: function(channel, action){
		// this isnt working in IE 8...why?
		// window[action.function].apply(window, action.args);
	},
			
	display_status: function(channel, message, timestamp){
		var html = '<p class="status">' + MadChatter.get_time_html(timestamp) + message + '</p>';
		$('.channel[data-channel="' + channel + '"] .messages').append(html);
	},
	
	display_message: function(channel, username, message, timestamp){
		var html = '<p class="message">' + MadChatter.get_time_html(timestamp) + '<span class="username">' + username + ':</span> ' + message + '</p>';
		$('.channel[data-channel="' + channel + '"] .messages').append(html);
	},
	
	get_time_html: function(timestamp){
		var html = '';
		var last_message_time = MadChatter.last_message_time;
		var	current_time = MadChatter.get_time_string(timestamp);
		if (last_message_time != current_time) {
			MadChatter.last_message_time = current_time;
			html = '<time>' + current_time + '</time>';
		}
		return html;
	},
	
	get_time_string: function(timestamp){
		var time = new Date(timestamp*1000); //timestamp must me in milliseconds
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
