// This function is called when '/alert' is sent in a chat message
function show_alert(message) {
	alert(message);
}

// This function is called when '/earthquake' is sent as a chat message
function earthquake() {
	var n = 4;
	if (parent.moveBy) {
		for (i = 10; i > 0; i--) {
			for (j = n; j > 0; j--) {
				parent.moveBy(0, i);
				parent.moveBy(i, 0);
				parent.moveBy(0, -i);
				parent.moveBy(-i, 0);
			}
		}
	}
}