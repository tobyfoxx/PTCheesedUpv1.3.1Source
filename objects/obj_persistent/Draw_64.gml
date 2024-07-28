live_auto_call;

toggle_alphafix(true);

// fps count
if global.showfps && global.option_hud
&& (!instance_exists(obj_version) or instance_exists(obj_option))
&& !instance_exists(obj_disclaimer) && !instance_exists(obj_loadingscreen)
{
	draw_set_font(SUGARY ? lang_get_font("smallfont") : lang_get_font("font_small"));
	draw_set_colour(c_white);
	draw_set_align(fa_right, fa_bottom);
	
	var xx = SCREEN_WIDTH - 20;
	var yy = SCREEN_HEIGHT - 12;
	
	if global.option_timer && !(room == Realtitlescreen || room == Longintro || room == Finalintro || room == Mainmenu || room == hub_loadingscreen || room == Creditsroom || room == Johnresurrectionroom || room == rank_room || instance_exists(obj_titlecard) || !global.option_hud
	|| room == characterselect || room == editor_entrance or room == room_cancelled)
	{
		xx -= 4;
		yy -= 18;
	}
	
	draw_text_transformed(xx, yy, string(fps), 1, 1, 0);
}
draw_set_align();

// the good meter
if global.goodmode
{
	draw_set_colour(c_white);
	draw_set_align(fa_center);
	draw_set_font(lang_get_font("font_small"));
	draw_text(SCREEN_WIDTH / 2 + random_range(-multiplier, multiplier), 32 + random_range(-multiplier, multiplier), concat("Good Mode ", multiplier, "x"));
}

// gif
if keyboard_check_pressed(vk_f11) && DEBUG
{
	gif_record = !gif_record;
	if gif_record
		gif_image = gif_open(SCREEN_WIDTH, SCREEN_HEIGHT);
	else
	{
		gif_save(gif_image, $"screenshots/{DATE_TIME_NOW}.gif");
		if !window_get_fullscreen() && os_type == os_windows
			launch_external($"explorer.exe \"{game_save_id}screenshots\\\"");
	}
}
if gif_record
{
	gif_add_surface(gif_image, application_surface, 2);
	
	draw_set_colour(c_red);
	draw_set_align(fa_center);
	draw_set_font(global.font_small);
	draw_text(SCREEN_WIDTH / 2, 32, "Recording GIF");
}

// global message
if gotmessage.time != -1
{
	// black overlay
	draw_set_colour(c_black);
	draw_set_alpha(is_string(gotmessage.author) ? 0.25 : 0.75);
	draw_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, false);
	
	// prepare text
	draw_set_alpha(1);
	draw_set_colour(c_white);
	draw_set_font(global.font_small);
	
	// person says...
	draw_set_align(fa_center, fa_middle);
	if is_string(gotmessage.author)
		draw_text(SCREEN_WIDTH / 2, (SCREEN_HEIGHT / 2) - 20, $"{gotmessage.author} says...\n");
	else
	{
		var str = "Global Message\n";
		switch gotmessage.author
		{
			case 1:
				str = "You've been kicked!";
				break;
		}
		draw_text(SCREEN_WIDTH / 2, (SCREEN_HEIGHT / 2) - 20, str);
	}
	
	// message
	draw_set_align(fa_center);
	var msgstr = gotmessage.message;
	if !is_string(msgstr)
		msgstr = "(error)";
	draw_text_ext_transformed((SCREEN_WIDTH / 2) + random_range(-1, 1), SCREEN_HEIGHT / 2 - 32, "\n" + msgstr, 16, SCREEN_WIDTH / 2, 2, 2, 0);
	
	// reset align
	draw_set_align();
	gotmessage.time--;
}
