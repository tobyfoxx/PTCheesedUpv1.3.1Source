live_auto_call;

//if keyboard_check_pressed(ord("R")) && DEBUG
//	event_perform(ev_create, 0);

image_alpha = Approach(image_alpha, 1, 0.1);

draw_set_alpha(1);
switch menu
{
	case 0:
		if !surface_exists(surface)
			surface = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT);
		
		surface_set_target(surface);
		switch state
		{
			case 0:
				draw_clear_alpha(c_black, image_alpha * .7);
		
				var img_modifier = sel == 0 ? (floor(image_index / 2) % 2) : 0;
				var img_replay = sel == 1 ? (floor(image_index / 2) % 2) : 0;
				
				var alpha_modifier = image_alpha;
				var alpha_replay = image_alpha;
		
				draw_sprite_ext(spr_gate_modifiers, img_modifier, SCREEN_WIDTH / 2 - 230, SCREEN_HEIGHT / 2 + 30 + 5, 1, 1, 0, c_black, alpha_modifier);
				draw_sprite_ext(spr_gate_replays, img_replay, SCREEN_WIDTH / 2 + 230, SCREEN_HEIGHT / 2 + 30 + 5, 1, 1, 0, c_black, alpha_replay);
		
				draw_sprite_ext(spr_gate_modifiers, img_modifier, SCREEN_WIDTH / 2 - 230, SCREEN_HEIGHT / 2 + 30, 1, 1, 0, sel == 0 ? c_white : c_dkgray, alpha_modifier);
				draw_sprite_ext(spr_gate_replays, img_replay, SCREEN_WIDTH / 2 + 230, SCREEN_HEIGHT / 2 + 30, 1, 1, 0, sel == 1 ? c_white : c_dkgray, alpha_replay);
				
				var info = get_pep_palette_info();
				if info.paletteselect != 1
				{
					pal_swap_player_palette(spr_gate_modifiers, 2 + img_modifier,,,, true);
					draw_sprite_ext(spr_gate_modifiers, 2 + img_modifier, SCREEN_WIDTH / 2 - 230, SCREEN_HEIGHT / 2 + 30, 1, 1, 0, sel == 0 ? c_white : c_dkgray, alpha_modifier);
					
					pal_swap_player_palette(spr_gate_replays, 2 + img_replay,,,, true);
					draw_sprite_ext(spr_gate_replays, 2 + img_replay, SCREEN_WIDTH / 2 + 230, SCREEN_HEIGHT / 2 + 30, 1, 1, 0, sel == 1 ? c_white : c_dkgray, alpha_replay);
					
					pal_swap_reset();
				}
				break;
			
			case 1:
			case 2:
				if state == 1
				{
					anim_t = Approach(anim_t, 1, .07);
					var curve = animcurve_channel_evaluate(outback, anim_t);
					
					var yy = lerp(SCREEN_HEIGHT / 2 + 30, SCREEN_HEIGHT / 2, curve);
					var xx = lerp(SCREEN_WIDTH / 2 + (sel == 0 ? -230 : 230), SCREEN_WIDTH / 2, curve);
					
					draw_clear_alpha(c_black, (image_alpha * .7) - anim_t);
					
					var spr = sel == 0 ? spr_gate_modifiers : spr_gate_replays;
				
					draw_sprite_ext(spr_gate_tv, 0, xx, yy + 5, 1, 1, 0, c_black, 1);
					draw_sprite_ext(spr, 0, xx, yy, 1, 1, 0, c_white, 1 - anim_t);
					
					pal_swap_player_palette(spr, 2,,,, true);
					draw_sprite_ext(spr, 2, xx, yy, 1, 1, 0, c_white, 1 - anim_t);
					
					draw_sprite_ext(spr_gate_tv, 0, xx, yy, 1, 1, 0, c_white, 1);
					if anim_t >= 1
					{
						sound_play("event:/modded/sfx/diagopen");
						anim_t = 0;
						state = 2;
					}
				}
				else
				{
					var xx = SCREEN_WIDTH / 2, yy = SCREEN_HEIGHT / 2;
					
					draw_clear_alpha(0, 0);
					anim_t = Approach(anim_t, 1, .05);
					var curve = lerp(1, 4, animcurve_channel_evaluate(outback, anim_t));
					
					if curve >= 4
						state = 3;
				}
				
				if !surface_exists(clip_surface)
					clip_surface = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT);
				surface_set_target(clip_surface);
				
				var scale = state == 1 ? 1 : curve;
				
				draw_clear_alpha(c_white, state == 1 ? .3 + anim_t : 1);
				gpu_set_blendmode(bm_subtract);
				draw_sprite_ext(spr_gate_tv, 1, xx, yy, scale, scale, 0, c_white, 1);
				gpu_set_blendmode(bm_normal);
				
				surface_reset_target();
				
				draw_clear_alpha(0, 0);
				draw_sprite_tiled(SUGARY ? bg_options_ss : spr_optionsBG, 5, ++x, x);
				
				gpu_set_blendmode(bm_subtract);
				draw_surface(clip_surface, 0, 0);
				gpu_set_blendmode(bm_normal);
				
				draw_sprite_ext(spr_gate_tv, 0, xx, yy, scale, scale, 0, c_white, 1);
				break;
			
			case 3:
				state = 0;
				alpha = 0;
				menu = sel == 0 ? 1 : 2;
				break;
		}
		surface_reset_target();
		
		toggle_alphafix(true);
		draw_surface(surface, 0, 0);
		break;
	
	case 1:
		alpha = Approach(alpha, 1, 0.2);
		draw_sprite_tiled(SUGARY ? bg_options_ss : spr_optionsBG, 5, ++x, x);
		event_inherited();
		break;
}

// fader
draw_set_alpha(fadealpha);
draw_set_colour(c_black);

toggle_alphafix(true);

draw_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, false);
draw_set_alpha(1);

toggle_alphafix(false);
