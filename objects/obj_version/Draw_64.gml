draw_set_font(lang_get_font("smallfont"));
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);
var a = 0;
with (obj_mainmenu)
	a = extrauialpha;
draw_text_color(SCREEN_WIDTH - 8, SCREEN_HEIGHT - 8, concat(lstr("mod_version_prefix"), ver, "\n", lstr("base_version_prefix"), lstr("game_version")), c_white, c_white, c_white, c_white, a);
