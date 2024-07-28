draw_set_alpha(1);
if hud_is_forcehidden()
	exit;

if global.hud == 1
	scr_cameradraw_old();
else
	scr_cameradraw();
