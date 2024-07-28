for (var i = 0; i < ds_list_size(global.afterimage_list); i++)
{
	var b = ds_list_find_value(global.afterimage_list, i);
	with (b)
	{
		if (visible)
		{
			b = image_blend;
			var a = other.alpha[identifier];
			var shd = false;
			
			gpu_set_blendmode(bm_normal);
			shader_reset();
			
			if (identifier == afterimage.firemouth)
			{
				a = alpha;
				shd = true;
				draw_set_flash(make_color_rgb(255 * 0.97, 255 * 0.43, 255 * 0.09));
			}
			else if (identifier == afterimage.blue)
			{
				a = alpha;
				shd = true;
				draw_set_flash(global.blueimg_color);
			}
			else if (identifier == afterimage.enemy or (identifier == afterimage.heatattack && REMIX))
			{
				a = alpha;
				shd = true;
				draw_set_flash(make_color_rgb(233, 47, 0));
			}
			else if (identifier == afterimage.fakepep)
			{
				a = alpha;
				shd = true;
				draw_set_flash(c_red);
			}
			else if (identifier == afterimage.noise)
			{
				a = alpha;
				shd = true;
				shader_set(shd_noise_afterimage);
				
				if !object_exists(playerid) or !instance_exists(playerid)
					exit;
				
				var pal = 1;
				if playerid.paletteselect == 0
					pal = 5;
				noise_aftimg_set_pal(playerid.spr_palette, playerid.paletteselect, pal);
				
				if playerid.object_index == obj_otherplayer
					noise_aftimg_set_pattern(playerid.pattern, 0);
				else
					noise_aftimg_set_pattern(global.palettetexture, 0);
			}
			else if (identifier == afterimage.blur)
			{
				a = alpha;
				b = get_dark(other.image_blend, obj_drawcontroller.use_dark, true, x, y);
				
				if obj_drawcontroller.use_dark && SUGARY
				{
					shd = true;
					draw_set_flash(b);
				}
				else if instance_exists(playerid) && (playerid.object_index == obj_otherplayer or playerid.usepalette)
				{
					shd = true;
					
					if playerid.object_index == obj_player1
						pal_swap_player_palette();
					else if playerid.object_index == obj_otherplayer
					{
						pal_swap_set(playerid.spr_palette, playerid.paletteselect, false);
						pattern_set(playerid.color_array, sprite_index, image_index, image_xscale, image_yscale, playerid.pattern);
					}
					else if playerid.object_index == obj_swapmodegrab
					{
						pal_swap_set(playerid.spr_palette, playerid.paletteselect, false);
						pattern_set(playerid.color_array, sprite_index, image_index, image_xscale, image_yscale, playerid.patterntexture);
					}
				}
			}
			else if ((identifier == afterimage.mach3effect or identifier == afterimage.simple)/* && REMIX*/)
			{
				var trans = check_char("SP");
				if !global.performance
				{
					shader_set(shd_mach3effect);
					shd = true;
					
					if REMIX or trans
					{
						shader_set_uniform_i(shader_get_uniform(shd_mach3effect, "raw"), 0);
						
						shader_set_uniform_f(other.color1, color_get_red(b) / 255, color_get_green(b) / 255, color_get_blue(b) / 255);
						b = make_color_hsv(color_get_hue(b), color_get_saturation(b) * 1.25, trans ? 75 : 35);
						shader_set_uniform_f(other.color2, color_get_red(b) / 255, color_get_green(b) / 255, color_get_blue(b) / 255);
						
						b = c_white;
					}
					else
					{
						shader_set_uniform_i(shader_get_uniform(shd_mach3effect, "raw"), 1);
						
						if b == global.mach_color1
							b = other.mach_color1;
						if b == global.mach_color2
							b = other.mach_color2;
					}
				}
				else
				{
					if b == global.mach_color1
						b = other.mach_color1;
					if b == global.mach_color2
						b = other.mach_color2;
				}
			}
			
			if instance_exists(playerid) && playerid.object_index == obj_otherplayer
				a *= global.online_opacity;
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, b, a);
			
			if shd
			{
				cuspal_reset();
				pattern_reset();
				pal_swap_reset();
				draw_reset_flash();
			}
		}
	}
}
