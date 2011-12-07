function get_current_time(){
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

var MadChatter = {
	
	init: function(ws_host){
		if (typeof WebSocket === 'undefined') {
	    	alert("Your browser does not support websockets.")
			return false;
	    }
		MadChatter.init_websocket(ws_host);
		$('#chatroom').hide();
		MadChatter.wait_for_join();
		MadChatter.wait_for_chat_submit();
	},
	
	init_websocket: function(ws_host){
		var ws =  new WebSocket(ws_host);
		ws.onopen = function(){};
		ws.onclose = function(){
			MadChatter.display_status('You have been disconnected');
		};
		ws.onmessage = function(evt){
			//console.log(evt.data)
			var data = JSON.parse(evt.data);
			MadChatter.message_received(data.type, data.username, data.message);
		};
		MadChatter.ws = ws;
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
	
	wait_for_chat_submit: function(){
		var keyboard = $("#keyboard input");
	    keyboard.keyup(function (event) {
	      if (event.keyCode == 13) { // The enter key.
			MadChatter.send_message(keyboard.val());
	        keyboard.val('');
	      }
	    });
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
			MadChatter.run_action(message);
		}
		if (type == 'message') {
			MadChatter.display_message(username, message);
		}
		MadChatter.scroll_to_bottom_of_chat();
	},
	
	update_users_list: function(users){
		$("#members").html('');
		$.each(users, function(index, username) {
		  $("#members").append('<li>' + username + '</li>');
		});
	},

	run_action: function(action){
		eval(action);
	},
			
	display_status: function(message){
		$("#messages").append("<p class='status'>" + message + "<time>" + get_current_time() + "</time></p>");
	},
	
	display_message: function(username, message){
		$("#messages").append("<p class='message'><span class='username'>" + username + ":</span> " + message + "<time>" + get_current_time() + "</time></p>");
	},
	
	scroll_to_bottom_of_chat: function(){
		$("body")[0].scrollTop = $("#messages")[0].scrollHeight;
	},
	
	send_message: function(message){
		MadChatter.send_json('message', message);
	},
	
	send_json: function(type, msg){
		var json = { type: type, token: MadChatter.client_token, message: msg };
		MadChatter.ws.send(JSON.stringify(json));
	}
};
