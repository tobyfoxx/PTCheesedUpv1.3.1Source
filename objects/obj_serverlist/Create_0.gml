live_auto_call;

instance_destroy(obj_onlineclient);
sound_play("event:/modded/sfx/diagopen");

pto_textbox_init();
depth = -100;

bgscroll = 0;
state = 0;

t = 0;
outback = animcurve_get_channel(curve_menu, "outback");
incubic = animcurve_get_channel(curve_menu, "incubic");

surfclip = noone;
surffinal = noone;

draw_box = function(x, y, w, h, txo = 0, tyo = 0)
{
	if !surface_exists(surfclip)
		surfclip = surface_create(w, h);
	else
		surface_resize(surfclip, w, h);
	
	if !surface_exists(surffinal)
		surffinal = surface_create(w, h);
	else
		surface_resize(surffinal, w, h);
	
	var xx = x;
	var yy = y;
	
	draw_sprite_ext(spr_tutorialbubble_rope, 0, xx + 16, y + 16, 1, y / 61 + 1, 0, c_white, 1);
	draw_sprite_ext(spr_tutorialbubble_rope, 0, xx + w - 16, y + 16, 1, y / 61 + 1, 0, c_white, 1);
	
	var shd = shader_current();
	shader_reset();
	
	// draw dialog box
	surface_set_target(surfclip);
	draw_clear_alpha(0, 0);
	draw_rectangle_color(0, 0, w, h, c_white, c_white, c_white, c_white, false);
	gpu_set_blendmode(bm_subtract);
	draw_sprite_ext(spr_tutorialbubble, 0, 0, 0, w / 96, h / 96, 0, c_white, 1);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	// draw the looping texture
	surface_set_target(surffinal);
	draw_sprite_tiled(bg_serverlist, 0, bgscroll + txo, bgscroll + tyo);
	gpu_set_blendmode(bm_subtract);
	draw_surface(surfclip, 0, 0);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	// draw everything
	shader_set(shd);
	draw_surface(surffinal, x, y);
	draw_sprite_ext(spr_tutorialbubble, 1, xx, yy, w / 96, h / 96, 0, c_white, 1);
}
