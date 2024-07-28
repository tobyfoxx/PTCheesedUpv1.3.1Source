var appId = int64(extension_get_option_value("Discord", "appId"));
state = Discord_Core_Create(appId);

active = false;
character = "";

if YYC
{
	a = "";
	if !state
	{
		show_message("Failed to start Discord Rich Presence.");
		game_end();
	}
}
