live_auto_call;

var xx = x + irandom_range(-1, 1);
var yy = y + irandom_range(-1, 1);

if global.laps < 2
	draw_sprite(sprite_index, image_index, xx, yy);
else if global.lapmode == lapmode.laphell
	draw_sprite(spr_lap3, global.laps == 3, xx, yy);
else
{
	draw_sprite(sprite_index, 1, xx, yy);
	
	if sugary
	{
		draw_set_font(global.lapfont2_ss);
		
		var w = 37 - string_width(global.laps + 1);
		draw_set_align(fa_center);
		draw_set_colour(c_white);
		draw_text(xx + 38 - ceil(w / 10), yy + 52, global.laps + 1);
		draw_set_align();
		
		draw_sprite(sprite_index, 2, xx + w / 3, yy);
	}
	else
	{
		var lap_text = string(global.laps + 1);
		var wd = sprite_get_width(spr_lapfontbig) * string_length(lap_text);
		
		shader_reset();
		
		// numbers!
		gpu_set_alphatestenable(true);
		
		for(var i = 1; i <= string_length(lap_text); i++)
		{
			var lx = xx - 8 + 39 * i - ((wd - 64) / 3);
			var ly = yy + 8;
			var letter = ord(string_char_at(lap_text, i)) - ord("0");
			
			gpu_set_blendmode_ext(bm_dest_color, bm_zero);
			draw_set_flash(#88A8C8);
			draw_sprite(spr_lapfontbig, letter, lx, ly + 3);
			draw_reset_flash();
			
			gpu_set_blendmode(bm_normal);
			draw_sprite(spr_lapfontbig, letter, lx, ly);
		}
		
		// the thingy
		gpu_set_blendmode(bm_normal);
		draw_sprite(sprite_index, 2, xx - ((wd - 64) / 3), yy);
		gpu_set_blendmode_ext(bm_dest_color, bm_zero);
		draw_sprite(sprite_index, 3, xx - ((wd - 64) / 3), yy);
		gpu_set_blendmode(bm_normal);
		
		gpu_set_alphatestenable(false);
	}
}

toggle_alphafix(true);
