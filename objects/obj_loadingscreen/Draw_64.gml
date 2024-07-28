if dark
	draw_rectangle_color(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0, false);
else if !instance_exists(obj_player)
	scr_draw_pause_image();
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
draw_set_font(lang_get_font("creditsfont"));
draw_text_color(SCREEN_WIDTH - 16, SCREEN_HEIGHT - 16, lang_get_value("menu_loading"), c_white, c_white, c_white, c_white, 1);
