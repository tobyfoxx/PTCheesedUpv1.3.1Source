draw_set_font(lang_get_font("bigfont"));
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_set_alpha(1);

if hud_is_forcehidden()
	exit;

if global.hud == 1
	scr_tvdraw_old();
else
	scr_tvdraw();
