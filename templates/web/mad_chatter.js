var MadChatter = {
	
	init: function(ws_host){
		if (typeof WebSocket === 'undefined') {
	    	alert("Your browser does not support websockets.")
			return false;
	    }
		MadChatter.init_websocket(ws_host);
		$('#chatroom').hide();
		MadChatter.wait_for_join();
		MadChatter.add_markdown_editor();
	},
	
	init_websocket: function(ws_host){
		var ws =  new WebSocket(ws_host);
		ws.onopen = function(){};
		ws.onclose = function(){
			MadChatter.display_status('You have been disconnected');
			setTimeout('("MadChatter.reconnect('+ws_host+'")', 10000);
		};
		ws.onmessage = function(evt){
			//console.log(evt.data)
			var data = JSON.parse(evt.data);
			MadChatter.message_received(data.type, data.username, data.message);
		};
		MadChatter.ws = ws;
	},
	
	reconnect: function(){
		console.log('trying to reconnect...');
	},
	
	wait_for_join: function(){
		$('#username').keyup(function (event) {
			if (event.keyCode == 13) { // The enter key.
				MadChatter.join_chat();
			}
	    });
		$('#join').click(function(){
			MadChatter.join_chat();
		});
	},
	
	add_markdown_editor: function(){
		var config = {
			previewParserPath: '',
			onEnter: {keepDefault:false, afterInsert: MadChatter.submit_chat },
			onShiftEnter: {keepDefault:false, openWith:'\n\n'},
			markupSet: [	
				{name:'Bold', key:'B', openWith:'**', closeWith:'**'},
				{name:'Italic', key:'I', openWith:'_', closeWith:'_'},
				{separator:'---------------' },
				{name:'Picture', key:'P', replaceWith:'![[![Alternative text]!]]([![Url:!:http://]!])'},
				{name:'Link', key:'L', openWith:'[', closeWith:']([![Url:!:http://]!])', placeHolder:'Your text to link here...' },
				{separator:'---------------'},	
				{name:'Quotes', openWith:'> '},
				{name:'Code Block / Code', openWith:'(!(\t|!|`)!)', closeWith:'(!(`)!)'}
			]
		};
		$('#keyboard textarea').markItUp(config);
	},
	
	join_chat: function(){
		var username = $.trim($('#username').val());
		if (username.length == 0) {
			alert('Please enter your name.');
			return false;
		}
		MadChatter.send_message('/join ' + username);
		$('#login_screen').hide();
		$('#chatroom').show();
	},
	
	submit_chat: function(){
		var keyboard = $("#keyboard textarea"), message = keyboard.val();
		if ($.trim(message) != '') {
			MadChatter.send_message(message);
			keyboard.val('');
		}
	},
	
	message_received: function(type, username, message){
		if (type == 'error') {
			console.log('Client error: ' + message)
			return;
		}
		if (type == 'token') {
			MadChatter.client_token = message;
			return;
		}
		if (type == 'users') {
			MadChatter.update_users_list(message);
			return;
		}
		if (type == 'status') {
			MadChatter.display_status(message);
		}
		if (type == 'action') {
			MadChatter.exec_action(message);
		}
		if (type == 'message') {
			MadChatter.display_message(username, message);
			if (typeof(MadChatterGrowl) != 'undefined') {
				MadChatterGrowl.send_(username, message);
			}
		}
		MadChatter.scroll_to_bottom_of_chat();
	},
	
	update_users_list: function(users){
		$("#members").html('');
		$.each(users, function(index, username) {
		  $("#members").append('<li>' + username + '</li>');
		});
	},

	exec_action: function(message){
		window[message.function].apply(window, message.args);
	},
			
	display_status: function(message){
		$("#messages").append("<p class='status'>" + message + "<time>" + MadChatter.get_current_time() + "</time></p>");
	},
	
	display_message: function(username, message){
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
