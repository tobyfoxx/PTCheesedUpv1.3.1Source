function scr_vigi_shoot()
{
	if live_call() return live_result;
	
	var letgo = (sprite_index == spr_playerV_revolverhold or sprite_index == spr_playerV_revolverstart or sprite_index == spr_playerV_airrevolverstart);
	if (input_buffer_pistol > 0 or letgo) && pistolcooldown <= 0
	{
		input_buffer_pistol = 0;
		if key_up
		{
			state = states.punch;
			image_index = 0;
			sprite_index = spr_breakdanceuppercut;
			fmod_event_instance_play(snd_uppercut);
			vsp = -19;
			movespeed = hsp;
		}
		else if state == states.normal or state == states.crouch
		{
			if move == 0
				movespeed = 0;
			sprite_index = spr_playerV_revolverstart;
			image_index = 0;
			state = states.revolver;
		}
		else
		{
			pistolcooldown = 10;
			if state != states.revolver
			{
				vsp = min(vsp, -6);
				state = states.revolver;
				sprite_index = spr_playerV_airrevolver;
			}
			else
				sprite_index = grounded ? spr_playerV_revolvershoot : spr_playerV_airrevolver;
			image_index = 0;
			
			if abs(movespeed) < 4 && grounded
				movespeed -= 2;
			
			with instance_create(x + xscale * 20, y + 10, obj_vigibullet)
			{
				is_solid = false;
				copy_player_scale;
				
				repeat 2
				{
					with create_debris(x, y, spr_slimedebris)
						hsp = other.image_xscale * random_range(2, 8);
				}
			}
			sound_play_3d("event:/sfx/enemies/killingblow", x, y);
		}
	}
}
function scr_vigi_throw()
{
	if live_call() return live_result;
	
	if (key_chainsaw2 or key_shoot2) && !instance_exists(dynamite_inst) && !instance_exists(obj_vigihook)
	{
		if state == states.punch
		{
			if movespeed != 0
				xscale = sign(movespeed);
			if move != 0
				xscale = move;
			
			movespeed = abs(movespeed);
		}
		
		if state != states.normal && state != states.crouch
			vsp = -6;
		if move == 0 && !key_attack
			movespeed = 0;
		
		image_index = 0;
		sprite_index = spr_playerV_dynamitethrow;
		
		var mv = movespeed + 4, mv2 = floor(movespeed * 1.2);
		if state == states.normal or state == states.jump
			mv = 6;
		if state == states.crouch
			mv = 0;
		
		state = states.dynamite;
		sound_play_3d("event:/sfx/vigilante/throw", x, y);
		
		if global.vigihook
		{
			var spd = 24, move_v = (key_down - key_up), move_h = (key_right + key_left);
			with instance_create(x, y, obj_vigihook)
			{
				playerid = other.id;
				hsp = move_h * spd;
				vsp = move_v * spd;
				
				if move_h == 0 && move_v == 0
					hsp = other.xscale * spd;
			}
		}
		else
		{
			with instance_create(x, y, obj_dynamite)
			{
				copy_player_scale;
			
				other.dynamite_inst = id;
				playerid = other.id;
				countdown = 150;
			
				if other.key_up && !other.key_down
				{
					movespeed = mv2;
					vsp = -12;
					if !other.grounded
						other.vsp = -10;
				}
				else
				{
					movespeed = mv;
					vsp = -6;
				}
			}
		}
	}
}

function scr_player_revolver()
{
	if live_call() return live_result;
	
	hsp = xscale * movespeed;
	move = key_left + key_right;
	landAnim = false;
	
	if grounded
		movespeed = Approach(movespeed, 0, 0.2);
	if sprite_index == spr_playerV_revolverstart
	{
		if image_index < 1
			image_index += 1;
		if floor(image_index) == image_number - 1
			sprite_index = spr_playerV_revolverhold;
	}
	
	if sprite_index == spr_playerV_revolverhold && !grounded
		sprite_index = spr_playerV_airrevolverstart;
	if sprite_index == spr_playerV_airrevolverstart && grounded
	{
		instance_create(x, y, obj_landcloud);
		sound_play_3d(sfx_playerstep, x, y);
		image_index = 0;
		sprite_index = spr_playerV_revolverhold;
	}
	
	if sprite_index == spr_playerV_revolvershoot
	{
		if floor(image_index) == image_number - 1
		{
			if !key_slap
			{
				image_index = 0;
				state = states.normal;
				sprite_index = spr_playerV_revolverend;
				movespeed = 2;
			}
			else
				sprite_index = spr_playerV_revolverhold;
		}
		else if !key_slap
			scr_vigi_shoot();
		
		if move != 0
			movespeed = Approach(movespeed, 6 * move * xscale, .5);
	}
	else if !key_slap
		scr_vigi_shoot();
	
	if key_down2
	{
		sprite_index = spr_crouchslip;
		movespeed = max(movespeed, 12);
		state = states.tumble;
		sound_play_3d(sfx_crouchslide, x, y);
	}
	
	if ((sprite_index == spr_playerV_airrevolverend || sprite_index == spr_playerV_airrevolver || sprite_index == spr_playerV_airrevolverstart)
	&& grounded)
	{
		if (key_attack && movespeed >= 6)
			state = states.mach2;
		else
			state = states.normal;
	}
	
	if sprite_index == spr_playerV_airrevolver
	{
		if floor(image_index) >= image_number - 6 && move == -xscale
		{
			sprite_index = spr_playerV_airrevolverend;
			state = states.jump;
			pistolcooldown = 25;
			xscale = move;
		}
	}
	
	if pistolcooldown <= 0
	{
		if input_buffer_jump > 0 && grounded
		{
			input_buffer_jump = 0;
			sound_play_3d(sfx_jump, x, y);
			state = states.jump;
			jumpAnim = true;
			image_index = 0;
			sprite_index = spr_jump;
			vsp = -11;
			instance_create(x, y, obj_highjumpcloud2);
		}
		
		scr_dotaunt();
		if state == states.backbreaker
		{
			tauntstoredsprite = spr_idle;
			tauntstoredstate = states.normal;
		}
	}
	
	if sprite_index == spr_playerV_airrevolver && ((floor(image_index) == image_number - 1)
	or (image_index >= image_number - 6 && key_attack && scr_solid(x + xscale, y)))
	{
		if !key_slap
		{
			if move != 0
				xscale = move;
			if (key_attack && move != 0)
			{
				movespeed = max(movespeed, 6);
				state = states.mach2;
			}
			else if !grounded
			{
				sprite_index = spr_playerV_airrevolverend;
				state = states.jump;
			}
			else
			{
				image_index = 0;
				state = states.normal;
			}
		}
		else
			sprite_index = spr_playerV_airrevolverstart;
	}
	image_speed = 0.4;
}

function scr_player_dynamite()
{
	if live_call() return live_result;
	
	if global.vigihook
	{
		if grounded
			hsp = Approach(hsp, 0, 0.25);
		
		var hook = obj_vigihook;
		if !instance_exists(hook) or hook.state == 10
		{
			if key_attack && hsp != 0
			{
				movespeed = min(movespeed, 6);
				state = states.mach2;
			}
			else
				state = states.normal;
			exit;
		}
		
		if hook.state == 1
		{
			sprite_index = spr_playerV_hookpull;
			if hsp != 0
				xscale = sign(hsp);
		}
		
		if hook.state == 2
		{
			hsp = 0;
			vsp = 0;
			
			if image_index >= image_number - 1
			{
				if sprite_index == spr_playerV_hookceilingstart
					sprite_index = spr_playerV_hookceiling;
				if sprite_index == spr_playerV_hookwallstart
					sprite_index = spr_playerV_hookwall;
			}
		}
		
		if input_buffer_jump > 0 && hook.state > 0
		{
			hook.state = 10;
			hook.speed = 5;
			
			input_buffer_jump = 0;
			
			image_speed = 0.35;
			if vsp > -11
				vsp = -11;
			
			if (sprite_index == spr_playerV_hookwallstart or sprite_index == spr_playerV_hookwall)
				xscale *= -1;
			
			sound_play_3d(sfx_jump, x, y);
			if key_attack && hsp != 0
			{
				sound_play_3d("event:/modded/sfx/kungfu", x, y);
				movespeed = min(movespeed, 6);
				state = states.mach2;
			}
			else
			{
				sprite_index = spr_jump;
				state = states.jump;
				jumpAnim = true;
			}
			
			if hsp != 0
			{
				xscale = sign(hsp);
				if abs(hsp) < 16
					movespeed = min(abs(hsp) + 4, 16);
				else
					movespeed = abs(hsp);
			}
		}
		
		if (floor(image_index) == (image_number - 1) && sprite_index == spr_playerV_dynamitethrow)
			image_speed = 0;
		else
			image_speed = 0.35;
	}
	else
	{
		if (grounded)
		{
			hsp = xscale * movespeed;
			if (movespeed > 0)
				movespeed -= 0.1;
		}
		//if (grounded)
		//	hsp = 0;
		landAnim = false;
		if (floor(image_index) == (image_number - 1) && sprite_index == spr_playerV_dynamitethrow)
		{
			if (key_attack && hsp != 0)
				state = states.mach2;
			else
				state = states.normal;
		}
		image_speed = 0.4;
	}
}
