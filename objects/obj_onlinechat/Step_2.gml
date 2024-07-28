if !instance_exists(obj_onlineclient)
	instance_destroy()
if obj_onlineclient.state != online_state.connected
{
	isOpen = false;
	exit;
}
if safe_get(obj_shell, "isOpen")
	exit;

if keyboard_check_pressed(vk_tab) or (keyboard_check_pressed(ord("T")) && !isOpen) or (keyboard_check_pressed(vk_escape) && isOpen)
{
	isOpen = !isOpen;
	keyboard_string = "";
}

if isOpen
{
	#region Keyboard Shortcuts
	
	if keyboard_check(vk_control)
	{
		// Cut
		if keyboard_check_pressed(ord("x"))
		{
			clipboard_set_text(inputText);
			inputText = "";
		}
		
		// Copy
		if keyboard_check_pressed(ord("c"))
			clipboard_set_text(inputText);
		
		// Paste
		if keyboard_check_pressed(ord("v")) && clipboard_has_text()
			inputText += clipboard_get_text();
		
		// Clear
		if keyboard_check_pressed(ord("u")) or keyboard_check_pressed(vk_backspace)
			inputText = "";
		
		exit;
	}
	
	#endregion
	#region Input History
	
	if keyboard_check_pressed(vk_up)
	{
		if textHistory != "" && inputText != textHistory
		{
			storedText = inputText;
			inputText = textHistory;
		}
	}
	if keyboard_check_pressed(vk_down)
	{
		if inputText == textHistory
			inputText = storedText;
	}
	
	#endregion
	#region Input Handling
	
	// Backspace
	if keyboard_check(vk_backspace)
	{ 
		inputText = string_delete(inputText, string_length(inputText), 1);
		keyboard_key_release(vk_backspace);
	}
	
	if keyboard_check(vk_anykey) && !keyboard_check(vk_tab) && string_length(inputText) < CHAT_MAXLEN
	{
		inputText += keyboard_string;
		for (var i = 0; i < string_length(keyboard_string); i++)
		{
			var b = string_char_at(keyboard_string, i + 1);
			keyboard_key_release(ord(b));
		}
		keyboard_string = "";
	}
	
	#endregion
	
	if keyboard_check_pressed(vk_enter)
	{
		scr_online_chat(inputText);
		textHistory = inputText;
		storedText = "";
		inputText = "";
		keyboard_string = "";
	}
}
