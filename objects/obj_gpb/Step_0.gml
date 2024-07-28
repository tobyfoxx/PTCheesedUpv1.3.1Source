if distance_to_object(obj_player1) <= 365
	looked = true;

if looked
{
	image_alpha = Approach(image_alpha, 2, 0.1);
	if image_alpha >= 2
	{
		ini_open_from_string(obj_savesystem.ini_str_options);
		ini_write_real("Modded", "con", 1);
		obj_savesystem.ini_str_options = ini_close();
		gamesave_async_save_options();
	
		scr_sleep(2000);
		game_end();
	}
}
