function scr_online_player()
{
	if live_call() return live_result;
	
	var spr = array_pop(string_split(sprite_get_name(sprite_index), "_", true, infinity));
	var hsp_now = x - xprevious, vsp_now = y - yprevious;
	var jump = false;

	var create_effect = function(x, y, object)
	{
		var yy = 0;
		if object == obj_highjumpcloud2
		{
			repeat 50
			{
				if scr_solid(x, y + yy + 1)
					break;
				if ++yy >= 50
					yy = 0;
			}
		}
		
		var inst = instance_create(x, y + yy, object);
		with inst
			image_alpha = global.online_opacity;
		return inst;
	}
	var play_sound = function(event, x, y)
	{
		if global.online_volume > 0
			return fmod_event_one_shot_3d_volume(event, x, y, global.online_volume);
	}
	
	// jump buffer
	if xprevious != x or yprevious != y
	{
		if vsp >= 0 && vsp_now < 0
		&& (scr_solid(x, y + 25 + vsp) or collision_line(x, bbox_bottom, x, bbox_bottom + 25 + vsp, obj_platform, 0, 0)
		or sprite_prev != sprite_index or grounded) && string_pos("jump", spr) != 0 && prevstate != states.backbreaker
			jump = true;
		
		if sprite_prev != sprite_index && string_pos("jump", spr) && spr != "secondjump2"
			jump = true;
		
		hsp = hsp_now;
		vsp = vsp_now;
		
		timer = 1;
	}
	else if timer-- <= 0
	{
		hsp = 0;
		vsp = 0;
	}
	
	grounded = scr_solid(x, y + 1);
	
	// CHANGE STATE
	if state != prevstate
	{
		switch state
		{
			case states.punch:
				if string_pos("uppercut", spr) != 0
				{
					play_sound(sfx_uppercut, x, y);
					create_effect(x, y, obj_highjumpcloud2);
				} 
				else if string_pos("kungfu", spr) != 0
					play_sound("event:/modded/sfx/kungfu", x, y);
				break;
			
			case states.handstandjump:
				sound_instance_move(suplexdashsnd, x, y);
				fmod_event_instance_play(suplexdashsnd);
				break;
				
			case states.Sjumpprep:
				sound_instance_move(sjumpsnd, x, y);
				fmod_event_instance_set_parameter(sjumpsnd, "state", 0, true);
				fmod_event_instance_play(sjumpsnd);
				break;
				
			case states.Sjump:
				sound_instance_move(sjumpsnd, x, y);
				fmod_event_instance_set_parameter(sjumpsnd, "state", 1, true);
				fmod_event_instance_play(sjumpsnd);
				break;
				
			case states.Sjumpland:
				play_sound(sfx_groundpound, x, y);
				break;
				
			case states.climbwall:
			case states.mach2:
				sound_instance_move(machsnd, x, y);
				fmod_event_instance_set_parameter(machsnd, "state", grounded ? 2 : 0, true);
				fmod_event_instance_play(machsnd);
				
				if spr == "sidewayspin"
					fmod_event_instance_play(airspinsnd);
				break;
				
			case states.mach3:
				sound_instance_move(machsnd, x, y);
				fmod_event_instance_set_parameter(machsnd, "state", 3, true);
				fmod_event_instance_play(machsnd);
				break;
				
			case states.machslide:
				if spr == "machslidestart"
					play_sound(sfx_break, x, y);
				else
					play_sound(sfx_machslideboost, x, y);
				break;
				
			case states.tumble:
				if spr == "crouchslip"
					play_sound(sfx_crouchslide, x, y);
				else if spr == "dive"
					play_sound(sfx_dive, x, y);
				else
					fmod_event_instance_play(machrollsnd);
				break;
				
			case states.freefall:
				sound_instance_move(freefallsnd, x, y);
				fmod_event_instance_play(freefallsnd);
				break;
				
			case states.freefallland:
				play_sound(sfx_groundpound, x, y);
				break;
				
			case states.slipbanan:
				play_sound(sfx_slip, x, y);
				break;
		}
		if prevstate == states.machcancel && state == states.mach3
		{
			play_sound("event:/sfx/playerN/wallbounceland", x, y);
			with create_effect(x, y, obj_noiseeffect)
			{
				sprite_index = spr_noisegrounddasheffect;
				image_xscale = other.image_xscale;
			}
			with create_effect(x, y, obj_crazyrunothereffect)
			{
				image_xscale = other.image_xscale;
				playerid = noone;
			}
		}
		if state != states.handstandjump
			fmod_event_instance_stop(suplexdashsnd, true);
		if state != states.Sjump && state != states.Sjumpprep
			fmod_event_instance_stop(sjumpsnd, true);
		if state != states.mach1 && state != states.mach2 && state != states.mach3 && state != states.climbwall
			fmod_event_instance_stop(machsnd, true);
		if state != states.freefall
			fmod_event_instance_stop(freefallsnd, true);
		if state != states.tumble
			fmod_event_instance_stop(machrollsnd, true);
	}
	if sprite_prev != sprite_index
	{
		image_index = 0;
		if spr == "taunt"
		{
			play_sound(sfx_taunt, x, y);
			create_effect(x, y, obj_baddietaunteffect);
			image_index = random(image_number);
		}
		if spr == "wallsplat" or spr == "suplexbump"
			play_sound(sfx_splat, x, y);
		if string_pos("bump", spr)
			create_effect(x + 10 * image_xscale, y + 10, obj_bumpeffect);
		if spr == "Sjumpcancelstart"
		{
			play_sound(sfx_superjumpcancel, x, y);
			fmod_event_instance_stop(sjumpsnd, true);
		}
		if spr == "longjump"
			play_sound(sfx_rollgetup, x, y);
		if spr == "kungfujump"
			play_sound(sfx_bumpwall, x, y);
		if spr == "mach3hitwall"
		{
			play_sound(sfx_bumpwall, x, y);
			play_sound(sfx_groundpound, x, y);
		}
		
		// noise
		if spr != "wallbounce"
			fmod_event_instance_stop(wallbouncesnd, true);
		else
		{
			sound_instance_move(wallbouncesnd, x, y);
			fmod_event_instance_play(wallbouncesnd);
			
			with create_effect(x, y + 20, obj_noiseeffect)
				sprite_index = spr_noisewalljumpeffect;
		}
		if string_pos("divebomb", spr) == 0
			fmod_event_instance_stop(drillsnd, true);
		else if !fmod_event_instance_is_playing(drillsnd)
			fmod_event_instance_play(drillsnd);
		if string_pos("sidewayspin", spr) == 0
		{
			if fmod_event_instance_is_playing(airspinsnd) && (state == states.Sjumpprep or state == states.mach3)
				play_sound("event:/sfx/playerN/wallbounceland", x, y);
			fmod_event_instance_stop(airspinsnd, true);
		}
		
		// transfo
		if state == states.slipbanan
		{
			if spr == "slipbanan2"
			{
				play_sound(sfx_slipend, x, y);
				play_sound(sfx_slipbump, x, y);
			}
			if spr == "rockethitwall"
				play_sound(sfx_slipbump, x, y);
		}
	}
	
	// STEP
	if spr != "breakdance"
		image_speed = 0.35;
	switch state
	{
		case states.tumble:
			sound_instance_move(machrollsnd, x, y);
			break;
		
		case states.jump:
		case states.crouchjump:
			if jump
			{
				image_index = 0;
				if state == states.jump
					create_effect(x, y, obj_highjumpcloud2);
				play_sound(sfx_jump, x, y);
			}
			break;
		
		case states.backbreaker:
			image_speed = 0;
			break;
		
		case states.handstandjump:
			sound_instance_move(suplexdashsnd, x, y);
			break;
		
		case states.normal:
			if abs(hsp) > 0
				image_speed = lerp(0.35, 0.6, abs(hsp) / 8);
			if string_pos("move", spr) && --afterimage_time <= 0
			{
				afterimage_time = 12;
				create_effect(x, y + 43, obj_cloudeffect);
				play_sound("event:/sfx/pep/step", x, y);
			}
			
			if spr == "breakdance" or spr == "breakdancing"
			{
				var before = breakdance_speed;
				
				breakdance_speed = Approach(breakdance_speed, 0.6, 0.005);
				image_speed = breakdance_speed;
				
				if breakdance_speed >= 0.5
				{
					if before < 0.5
					{
						sound_play_3d("event:/sfx/misc/breakdance", x, y);
						flash = 9;
					}
					if current_time % 10 == 0
						create_effect(x + random_range(-70, 70), y + random_range(-70, 70), obj_notes);
				}
			}
			break;
		
		case states.punch:
			if --afterimage_time <= 0
			{
				afterimage_time = 5;
				with create_blue_afterimage(x, y, sprite_index, image_index, image_xscale)
					playerid = other.id;
			}
			break;
			
		case states.Sjump:
			image_speed = 0.5;
			sound_instance_move(sjumpsnd, x, y);
			break;
			
		case states.Sjumpprep:
			sound_instance_move(sjumpsnd, x, y);
			break;

		case states.climbwall:
		case states.mach2:
		case states.mach3:
			var s = 0, g = grounded;
			if character == online_characters.noise
			{
				switch spr
				{
					case "mach1":
					case "mach":
					case "mach2":
					case "secondjump1":
					case "secondjump2":
					case "sidewayspin":
					case "sidewayspinend":
					case "longjump":
					case "longjumpend":
						s = 1;
						break;
					
					case "mach3":
					case "mach4":
					case "mach3jump":
						s = 2;
						break;
					
					case "crazyrun":
						s = 3;
						break;
				}
				if spr == "rollgetup"
					s = state == states.mach3 ? 2 : 1;
				if state == states.climbwall
				{
					s = 1;
					g = true;
				}
				fmod_event_instance_set_parameter(machsnd, "ground", g, true);
			}
			else
			{
				switch spr
				{
					case "mach1":
						s = grounded ? 1 : 0;
						break;
					
					case "mach":
					case "mach2":
						s = grounded ? 2 : 0;
						break;
					
					case "mach3":
					case "mach4":
					case "Sjumpcancel":
						s = 3;
						break;
					
					case "crazyrun":
						s = 4;
						break;
				}
				if spr == "rollgetup"
					s = state == states.mach3 ? 3 : 0;
				if state == states.climbwall
					s = 2;
			}
			fmod_event_instance_set_parameter(machsnd, "state", s, true);
			
			sound_instance_move(machsnd, x, y);
			sound_instance_move(airspinsnd, x, y);
			
			if jump
				play_sound(sfx_jump, x, y);
			break;
		
		case states.machcancel:
			sound_instance_move(wallbouncesnd, x, y);
			sound_instance_move(drillsnd, x, y);
			
			fmod_event_instance_set_parameter(drillsnd, "state", grounded, true);
			if string_pos("divebomb", spr)
				image_speed = (abs(hsp) / 40) + 0.4;
			else
				image_speed = 0.5;
			
			if --afterimage_time <= 0
			{
				afterimage_time = 5;
				with create_effect(x + random_range(5, -5), y + random_range(20, -20), obj_tornadoeffect)
					playerid = other.id;
				with create_noise_afterimage(x, y, sprite_index, image_index, image_xscale)
					playerid = other.id;
				if grounded && string_pos("divebomb", spr)
				{
					repeat 2
					{
						with create_effect(x + random_range(3, -3), y + 45, obj_noisedebris)
							sprite_index = spr_noisedrilldebris;
					}
				}
			}
			break;
			
		case states.freefall:
			sound_instance_move(freefallsnd, x, y);
			break;
	}
	
	if spr == "pistolshot" && image_index < image_speed 
	{
		image_speed = 0.35;
		play_sound(sfx_pistolshot, x, y);
		image_index = image_speed;
	}
	
	sprite_prev = sprite_index;
	prevstate = state;
	
	// state afterimages
	if state != states.normal
		breakdance_speed = 0.25;
	if breakdance_speed >= 0.6 or state == states.handstandjump
	{
		if --afterimage_time <= 0
		{
			afterimage_time = 2;
			with create_blur_afterimage(x, y, sprite_index, image_index, image_xscale)
				playerid = other.id;
		}
	}
	
	// instance sounds volume
	fmod_event_instance_set_volume(suplexdashsnd, global.online_volume);
	fmod_event_instance_set_volume(sjumpsnd, global.online_volume);
	fmod_event_instance_set_volume(freefallsnd, global.online_volume);
	fmod_event_instance_set_volume(airspinsnd, global.online_volume);
	fmod_event_instance_set_volume(wallbouncesnd, global.online_volume);
	fmod_event_instance_set_volume(machsnd, global.online_volume);
	fmod_event_instance_set_volume(drillsnd, global.online_volume);
	fmod_event_instance_set_volume(machrollsnd, global.online_volume);
}

function scr_online_destroysounds()
{
	destroy_sounds([
		suplexdashsnd,
		freefallsnd,
		airspinsnd,
		wallbouncesnd,
		drillsnd,
		machrollsnd,
			
		machsnd,
		sjumpsnd,
	]);
}

function scr_online_swapsounds(character, init = false)
{
	if live_call(character, init) return live_result;
	
	if !init
		scr_online_destroysounds();
	
	suplexdashsnd = fmod_event_create_instance(sfx_suplexdash);
	freefallsnd = fmod_event_create_instance(sfx_freefall);
	airspinsnd = fmod_event_create_instance(sfx_airspin);
	wallbouncesnd = fmod_event_create_instance(sfx_noisewallbounce);
	drillsnd = fmod_event_create_instance("event:/sfx/playerN/divebomb");
	machrollsnd = fmod_event_create_instance(sfx_machroll);
	
	switch character
	{
		case online_characters.noise:
			machsnd = fmod_event_create_instance(sfx_noisemach);
			sjumpsnd = fmod_event_create_instance(sfx_noiseSjump);
			break;
		default:
			machsnd = fmod_event_create_instance(sfx_mach);
			sjumpsnd = fmod_event_create_instance(sfx_superjump);
			break;
	}
}
