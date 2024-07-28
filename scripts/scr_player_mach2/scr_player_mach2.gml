function scr_player_mach2()
{
	var maxmovespeed = 12;
	var jumpspeed = -11;
	var slopeaccel = 0.1;
	var slopedeccel = 0.2;
	var accel = 0.1;
	var mach4accel = IT_FINAL ? 0.4 : 0.1;
	var machrollvsp = 10;
	
	if (windingAnim < 2000)
		windingAnim++;
	if (place_meeting(x, y + 1, obj_railparent))
	{
		var _railinst = instance_place(x, y + 1, obj_railparent);
		railmovespeed = _railinst.movespeed;
		raildir = _railinst.dir;
	}
	hsp = (xscale * movespeed) + (railmovespeed * raildir);
	move = key_right + key_left;
	
	if ceilingrun && move != 0
		move = xscale;
	
	crouchslideAnim = true;
	if (!key_jump2 && jumpstop == 0 && vsp < 0.5)
	{
		vsp /= 20;
		jumpstop = true;
	}
	if (grounded && vsp > 0)
		jumpstop = false;
	if (input_buffer_jump > 0 && can_jump && sprite_index != spr_clownjump && !((move == 1 && xscale == -1) or (move == -1 && xscale == 1)))
	{
		input_buffer_jump = 0;
		image_index = 0;
		sprite_index = spr_secondjump1;
		scr_fmod_soundeffect(jumpsnd, x, y);
		particle_set_scale(part.jumpdust, xscale, 1);
		create_particle(x, y, part.jumpdust, 0);
		if (skateboarding)
			sprite_index = spr_clownjump;
		vsp = jumpspeed;
		if character == "SN"
		{
			state = states.twirl;
			sprite_index = spr_pizzano_twirl;
			vsp = -12;
		}
	}
	
	if (input_buffer_jump > 0 && !can_jump && CHAR_BASENOISE && key_up && noisedoublejump && !skateboarding && sprite_index != spr_clownjump)
		scr_player_do_noisecrusher();
	
	var mortjump = false;
	if (key_jump && global.mort == 1 && sprite_index != spr_mortdoublejump && !grounded && !skateboarding)
	{
		state = states.jump;
		repeat (6)
			create_debris(x, y, spr_feather);
		sprite_index = spr_mortdoublejump;
		image_index = 0;
		grav = 0.25;
		with (instance_create(x, y, obj_highjumpcloud2))
			copy_player_scale;
		mort = true;
		mortjump = true;
	}
	if (grounded && vsp > 0)
	{
		if (sprite_index == spr_playerN_skateboarddoublejump)
		{
			sprite_index = spr_mach;
			sound_play_3d("event:/sfx/playerN/wallbounceland", x, y);
		}
		if (machpunchAnim == 0 && sprite_index != spr_mach && sprite_index != spr_mach1 && sprite_index != spr_mach4 && sprite_index != spr_player_machhit)
		{
			if (sprite_index != spr_player_machhit && sprite_index != spr_rollgetup && sprite_index != spr_suplexdash && sprite_index != spr_taunt && sprite_index != spr_Sjumpcancelstart)
				sprite_index = spr_mach;
		}
		if (machpunchAnim == 1)
		{
			if (punch == 0)
				sprite_index = spr_machpunch1;
			if (punch == 1)
				sprite_index = spr_machpunch2;
			if (floor(image_index) == 4 && sprite_index == spr_machpunch1)
			{
				punch = true;
				machpunchAnim = false;
			}
			if (floor(image_index) == 4 && sprite_index == spr_machpunch2)
			{
				punch = false;
				machpunchAnim = false;
			}
		}
	}
	if (floor(image_index) == (image_number - 1) && sprite_index == spr_mach1)
		sprite_index = spr_mach;
	if (floor(image_index) == (image_number - 1) && sprite_index == spr_longjump)
		sprite_index = spr_longjumpend;
	if (floor(image_index) == (image_number - 1) && sprite_index == spr_playerN_skateboarddoublejump)
		image_index = image_number - 3;
	if (sprite_index == spr_playerN_skateboarddoublejump && grounded && vsp > 0)
		sprite_index = spr_mach;
	
	if (!grounded)
		machpunchAnim = false;
	
	if (grounded)
	{
		if (IT_FINAL && (scr_slope() && hsp != 0) && movespeed > 8)
			scr_player_addslopemomentum(slopeaccel, slopedeccel);
		if (movespeed < maxmovespeed)
		{
			if (mach4mode == false)
				movespeed += accel;
			else
				movespeed += mach4accel;
		}
		if (abs(hsp) >= maxmovespeed && skateboarding == 0 && sprite_index != spr_suplexdash)
		{
			machhitAnim = false;
			state = states.mach3;
			flash = true;
			if (sprite_index != spr_rollgetup)
				sprite_index = spr_mach4;
			particle_set_scale(part.jumpdust, xscale, 1);
			create_particle(x, y, part.jumpdust, 0);
		}
	}
	if ((!grounded && (check_solid(x + hsp, y) || scr_solid_slope(x + hsp, y)) && !check_slope(x, y - 1) && !place_meeting(x + hsp, y, obj_destructibles))
	|| (grounded && (check_solid(x + sign(hsp), y - 16) || scr_solid_slope(x + sign(hsp), y - 16)) && !place_meeting(x + hsp, y, obj_destructibles) && check_slope(x, y + 1)))
	{
		var _climb = true;
		if CHAR_BASENOISE
			_climb = ledge_bump(32, abs(hsp) + 1);
		if (_climb)
		{
			if REMIX
			{
				while !scr_solid(x + xscale, y)
					x += xscale;
				hsp = 0;
			}
		
			wallspeed = movespeed;
			grabclimbbuffer = 0;
			if (movespeed < 1)
				wallspeed = 1;
			else
				movespeed = wallspeed;
			state = states.climbwall;
			if REMIX
				vsp = -wallspeed;
		}
	}
	if (!grounded && place_meeting(x + sign(hsp), y, obj_climbablewall) && !place_meeting(x + sign(hsp), y, obj_destructibles))
	{
		var _climb = true;
		if CHAR_BASENOISE
			_climb = ledge_bump(32, abs(hsp) + 1);
		if (_climb)
		{
			wallspeed = movespeed;
			grabclimbbuffer = 0;
			state = states.climbwall;
		}
	}
	if (!instance_exists(dashcloudid) && grounded)
	{
		with (instance_create(x, y, obj_dashcloud))
		{
			copy_player_scale;
			other.dashcloudid = id;
		}
	}
	if (grounded && floor(image_index) == (image_number - 1) && (sprite_index == spr_rollgetup || sprite_index == spr_rampjump))
		sprite_index = spr_mach;
	if (floor(image_index) == (image_number - 1) && sprite_index == spr_suplexdash)
		sprite_index = spr_mach;
	if (!grounded && sprite_index != spr_playerN_skateboarddoublejump && sprite_index != spr_playerN_sidewayspin && sprite_index != spr_playerN_grindcancel && sprite_index != spr_playerN_sidewayspinend
	&& sprite_index != spr_secondjump2 && sprite_index != spr_clownjump && sprite_index != spr_clownfall && sprite_index != spr_mach2jump && sprite_index != spr_walljumpstart && sprite_index != spr_taunt && sprite_index != spr_Sjumpcancelstart && sprite_index != spr_walljumpend && sprite_index != spr_longjump && sprite_index != spr_longjumpend
	&& sprite_index != spr_playerBN_grindJump)
	{
		sprite_index = spr_secondjump1;
		if (skateboarding)
			sprite_index = spr_clownfall;
	}
	if (floor(image_index) == (image_number - 1) && sprite_index == spr_secondjump1)
		sprite_index = spr_secondjump2;
	if (floor(image_index) == (image_number - 1) && sprite_index == spr_walljumpstart)
		sprite_index = spr_walljumpend;
	if (floor(image_index) == (image_number - 1) && sprite_index == spr_playerBN_grindJump)
		sprite_index = spr_mach2jump;
	if (!grounded && sprite_index != spr_clownfall && sprite_index == spr_clownjump && floor(image_index) == (image_number - 1))
		sprite_index = spr_clownfall;
	if (sprite_index == spr_playerN_sidewayspin && floor(image_index) == (image_number - 1))
		sprite_index = spr_playerN_sidewayspinend;
	if (grounded && (sprite_index == spr_playerN_sidewayspin || sprite_index == spr_playerN_grindcancel || sprite_index == spr_playerN_sidewayspinend))
		sprite_index = spr_mach;
	if (scr_mach_check_dive() && !skateboarding && sprite_index != spr_playerN_grindcancel && !place_meeting(x, y, obj_dashpad))
	{
		particle_set_scale(part.jumpdust, xscale, 1);
		create_particle(x, y, part.jumpdust, 0);
		flash = false;
		state = states.tumble;
		vsp = machrollvsp;
		
		if IT_FINAL
		{
			image_index = 0;
			if !grounded
				sprite_index = spr_mach2jump;
			else
				sprite_index = spr_machroll;
		}
		else
			state = states.machroll;
	}
	if !key_attack && movespeed >= 8 && grounded && vsp > 0 && skateboarding == 0
	{
		image_index = 0;
		state = states.machslide;
		if (scr_ispeppino())
			sound_play_3d("event:/sfx/pep/break", x, y);
		else
			sound_play_3d("event:/sfx/playerN/break", x, y);
		sprite_index = spr_machslidestart;
	}
	else if (!key_attack && movespeed < 8 && grounded && vsp > 0 && skateboarding == 0)
		state = states.normal;
	if (move == -xscale && movespeed >= 8 && grounded && vsp > 0 && skateboarding == 0)
	{
		if (scr_ispeppino())
			sound_play_3d("event:/sfx/pep/machslideboost", x, y);
		else
			sound_play_3d("event:/sfx/playerN/machslide", x, y);
		image_index = 0;
		state = states.machslide;
		sprite_index = spr_machslideboost;
	}
	else if (move == -xscale && movespeed < 8 && grounded && vsp > 0 && skateboarding == 0)
	{
		xscale *= -1;
		movespeed = 6;
	}
	if (clowntimer > 0 && skateboarding == 1)
		clowntimer--;
	if (clowntimer <= 0 && skateboarding == 1)
	{
		state = states.normal;
		create_particle(x, y, part.genericpoofeffect);
	}
	if character == "V"
	{
		scr_vigi_shoot();
		scr_vigi_throw();
	}
	if (sprite_index == spr_rollgetup || sprite_index == spr_longjumpend || sprite_index == spr_longjump || sprite_index == spr_suplexdash)
		image_speed = 0.4;
	else
		image_speed = abs(movespeed) / 15;
	scr_dotaunt();
	if (skateboarding && sprite_index != spr_clownjump && grounded)
		sprite_index = spr_clown;
	if (mortjump)
		sprite_index = spr_player_mortjumpstart;
	if (state != states.machslide && scr_solid(x + xscale, y) && !scr_slope() && (scr_solid_slope(x + sign(hsp), y) || check_solid(x + sign(hsp), y)) && !place_meeting(x + sign(hsp), y, obj_destructibles) && !place_meeting(x + sign(hsp), y, obj_climbablewall) && grounded)
	{
		if (skateboarding)
			xscale *= -1;
		else
		{
			var _bump = ledge_bump((vsp >= 0) ? 32 : 22);
			if (_bump)
			{
				sound_play_3d("event:/sfx/pep/splat", x, y);
				state = states.bump;
				image_index = 0;
				sprite_index = spr_wallsplat;
			}
		}
	}
	if character != "V" && character != "S" && IT_FINAL
	{
		// shoot
		if !skateboarding
		{
			if (input_buffer_shoot > 0 && shotgunAnim)
				scr_shotgunshoot();
			else if (input_buffer_pistol > 0 && global.pistol)
			or (global.shootstyle == 1 && key_shoot2)
				scr_pistolshoot(states.mach2);
			else if key_shoot2
				scr_perform_move(moves.shootattack, states.mach2);
		}
		
		var pistol = (global.pistol && scr_ispeppino());
		
		// grab
		if (input_buffer_grab > 0 && !key_up && !skateboarding && ((shotgunAnim == false && !global.pistol) or global.shootbutton == 1 or (global.shootbutton == 2 && !global.pistol)) && (!suplexmove or character != "SP"))
		{
			input_buffer_slap = 0;
			input_buffer_grab = 0;
			
			sprite_index = shotgunAnim ? spr_shotgunsuplexdash : spr_suplexdash;
			suplexmove = true;
			fmod_event_instance_play(suplexdashsnd);
			particle_set_scale(part.jumpdust, xscale, 1);
			create_particle(x, y, part.jumpdust, 0);
			state = states.handstandjump;
			if (movespeed < 5)
				movespeed = 5;
			image_index = 0;
		}
		
		// uppercut
		else if ((input_buffer_slap > 0 or input_buffer_grab > 0) && key_up && ((shotgunAnim == false && !pistol) or global.shootbutton == 1 or (global.shootbutton == 2 && !pistol)))
		{
			input_buffer_slap = 0;
			input_buffer_grab = 0;
			state = states.punch;
			image_index = 0;
			sprite_index = spr_breakdanceuppercut;
			fmod_event_instance_play(snd_uppercut);
			
			if character == "V"
				vsp = -19;
			else if character == "N"
				vsp = -21;
			else
				vsp = -10;
			
			movespeed = hsp;
			particle_set_scale(part.highjumpcloud2, xscale, 1);
			create_particle(x, y, part.highjumpcloud2, 0);
			
			if (scr_isnoise())
			{
				repeat (4)
				{
					with (instance_create(x + irandom_range(-40, 40), y + irandom_range(-40, 40), obj_explosioneffect))
					{
						sprite_index = spr_shineeffect;
						image_speed = 0.35;
					}
				}
			}
		}
	
		// kungfu
		else if input_buffer_slap > 0 && !key_up && !suplexmove && ((shotgunAnim == false && !global.pistol) or global.shootbutton == 1 or (global.shootbutton == 2 && !global.pistol))
		{
			input_buffer_slap = 0;
			scr_perform_move(moves.grabattack, states.mach2);
		}
	}
	
	/*
	if (global.attackstyle == 2 && key_slap2)
	{
		randomize_animations([spr_suplexmash1, spr_suplexmash2, spr_suplexmash3, spr_suplexmash4, spr_player_suplexmash5, spr_player_suplexmash6, spr_player_suplexmash7, spr_punch]);
		image_index = 0;
		state = states.lungeattack;
	}
	*/
	
	if (state != states.mach2 && fmod_event_instance_is_playing(rollgetupsnd))
		fmod_event_instance_stop(rollgetupsnd, true);
}
