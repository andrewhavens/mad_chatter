var MadChatter = {
	
	init: function(ws_host){
		if (typeof WebSocket === 'undefined') {
	    	alert("Your browser does not support websockets.")
			return false;
	    }
		MadChatter.init_websocket(ws_host);
		$('#chat_wrapper').hide();
		MadChatter.wait_for_join();
		// MadChatter.add_markdown_editor();
	},
	
	init_websocket: function(ws_host){
		var ws =  new WebSocket(ws_host);
		ws.onopen = function(){};
		ws.onclose = function(){
			MadChatter.display_status('You have been disconnected');
			// setTimeout('("MadChatter.reconnect('+ws_host+'")', 10000); //need to figure out how to re-join chat onopen
		};
		ws.onmessage = function(evt){
			//console.log(evt.data)
			var data = JSON.parse(evt.data);
			MadChatter.message_received(data);
		};
		MadChatter.ws = ws;
	},
	
	// reconnect: function(){
	// 	console.log('trying to reconnect...');
	// },
	
	wait_for_join: function(){
		// $('#username').keyup(function (event) {
		// 	if (event.keyCode == 13) { // The enter key.
		// 		MadChatter.join_chat();
		// 	}
		// 	    });
		// $('#join').click(function(){
		// 	MadChatter.join_chat();
		// });
		$('#pick_a_username').submit(function(e){
			e.preventDefault();
			MadChatter.join_chat();
		});
	},
	
	// add_markdown_editor: function(){
	// 	var config = {
	// 		previewParserPath: '',
	// 		onEnter: {keepDefault:false, afterInsert: MadChatter.submit_chat },
	// 		onShiftEnter: {keepDefault:false, openWith:'\n\n'},
	// 		markupSet: [	
	// 			{name:'Bold', key:'B', openWith:'**', closeWith:'**'},
	// 			{name:'Italic', key:'I', openWith:'_', closeWith:'_'},
	// 			{separator:'---------------' },
	// 			{name:'Picture', key:'P', replaceWith:'![[![Alternative text]!]]([![Url:!:http://]!])'},
	// 			{name:'Link', key:'L', openWith:'[', closeWith:']([![Url:!:http://]!])', placeHolder:'Your text to link here...' },
	// 			{separator:'---------------'},	
	// 			{name:'Quotes', openWith:'> '},
	// 			{name:'Code Block / Code', openWith:'(!(\t|!|`)!)', closeWith:'(!(`)!)'}
	// 		]
	// 	};
	// 	$('#keyboard textarea').markItUp(config);
	// },
	
	join_chat: function(){
		var username = $.trim($('#username').val());
		if (username.length == 0) {
			alert('Please enter your name.');
			return false;
		}
		MadChatter.send_message('/nick ' + username);
		// MadChatter.send_message('/join default');
		$('#login_screen').hide();
		$('#chat_wrapper').show();
		$('.join_room').on('click', function(e){
			e.preventDefault();
			//should probably check if already joined before joining again
			var channel_id = $(this).attr('data-id');
			MadChatter.send_message('/join ' + channel_id);
			$('#channel_tabs li').removeClass('active');
			$('#channel_tabs').append('<li class="active"><a href="#" data-id="' + channel_id + '">' + $(this).text() + '</a></li>');
			$('#room_template').clone().attr('id','').attr('data-id', channel_id).appendTo('#chat_wrapper').show();
		});
	},
	
	submit_chat: function(){
		var keyboard = $("#keyboard input"), message = keyboard.val();
		if ($.trim(message) != '') {
			MadChatter.send_message(message);
			keyboard.val('');
		}
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
		$("#messages").append("<p class='status'>" + message + "<time>" + MadChatter.get_current_time() + "</time></p>");
	},
	
	display_message: function(channel, username, message){
		$("#messages").append("<p class='message'><time>" + MadChatter.get_current_time() + "</time><span class='username'>" + username + ":</span> " + message + "</p>");
	},
	
	scroll_to_bottom_of_chat: function(){
		$("body")[0].scrollTop = $("#messages")[0].scrollHeight;
	},
	
	send_message: function(message){
		if (message == '/clear') {
			MadChatter.clear_messages();
		} else {
			MadChatter.send_json('message', message);
		}
	},
	
	send_json: function(type, msg){
		var json = { type: type, token: MadChatter.client_token, message: msg };
		MadChatter.ws.send(JSON.stringify(json));
	},
	
	clear_messages: function(){
		$('#messages').empty();
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
