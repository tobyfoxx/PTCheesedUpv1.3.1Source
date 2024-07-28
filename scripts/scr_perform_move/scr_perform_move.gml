enum moves
{
	grabattack,
	doublegrab,
	shootattack
}
function scr_perform_move(move, prestate = state)
{
	var attackstyle = global.attackstyle;
	var doublegrab = global.doublegrab;
	var shootstyle = global.shootstyle;
	
	if character == "SN"
	{
		attackstyle = 1; // kungfu
		doublegrab = 3; // chainsaw
		global.fuel = 3;
	}
	if move == moves.grabattack
	{
		switch attackstyle
		{
			case 1: // kung fu
				if grounded
				{
					with instance_create(x, y, obj_superdashcloud)
						copy_player_scale;
					sprite_index = choose(spr_kungfu1, spr_kungfu2, spr_kungfu3);
				}
				else
					sprite_index = choose(spr_kungfuair1transition, spr_kungfuair2transition, spr_kungfuair3transition);
				suplexmove = true;
							
				particle_set_scale(part.crazyrunothereffect, xscale, 1);
				create_particle(x, y, part.crazyrunothereffect);
					
				sound_play_3d("event:/modded/sfx/kungfu", x, y);
				state = states.punch;
				movespeed = max(movespeed, 10);
				if vsp > 0
					vsp = 0;
				image_index = 0;
				break;
						
			case 2: // shoulderbash
				if grounded
				{
					with instance_create(x, y, obj_superdashcloud)
						copy_player_scale;
					sprite_index = spr_attackdash;
				}
				else
					sprite_index = spr_airattackstart;
				suplexmove = true;
							
				particle_set_scale(part.crazyrunothereffect, xscale, 1);
				create_particle(x, y, part.crazyrunothereffect);
							
				fmod_event_instance_play(snd_dive);
				state = states.handstandjump;
				movespeed = max(movespeed, 10);
				image_index = 0;
				break;
			
			case 3: // lunge
				if !suplexmove
				{
					if grounded
					{
						with instance_create(x, y, obj_superdashcloud)
							copy_player_scale;
					}
					sprite_index = spr_lunge;
					suplexmove = true;
				
					particle_set_scale(part.jumpdust, xscale, 1);
					create_particle(x, y, part.jumpdust, 0);
					particle_set_scale(part.crazyrunothereffect, xscale, 1);
					create_particle(x, y, part.crazyrunothereffect);
							
					fmod_event_instance_play(suplexdashsnd);
					state = states.handstandjump;
					movespeed = max(movespeed, 10);
					vsp = 0;
					image_index = 0;
				}
				break;
		}
	}
	if move == moves.doublegrab
	{
		switch doublegrab
		{
			case 1: // shoulder bash
				if attackstyle != 2
				{
					if sprite_index != spr_attackdash && sprite_index != spr_airattackstart && sprite_index != spr_airattack
					&& !suplexmove2
					{
						fmod_event_instance_stop(suplexdashsnd, false);
						fmod_event_instance_play(snd_dive);
						
						state = states.handstandjump;
						image_index = 0;
						movespeed = max(movespeed, 10);
						
						particle_set_scale(part.crazyrunothereffect, xscale, 1);
						create_particle(x, y, part.crazyrunothereffect);
						
						if grounded
						{
							sprite_index = spr_attackdash;
							with instance_create(x + (xscale * -50), y, obj_superdashcloud)
								copy_player_scale;
						}
						else
						{
							suplexmove2 = true;
							if vsp > -4
								vsp = -4;
							sprite_index = spr_airattackstart;
						}
					}
				}
				else
				{
					// grab instead
					if sprite_index != spr_suplexdash && sprite_index != spr_shotgunsuplexdash
					{
						sprite_index = shotgunAnim ? spr_shotgunsuplexdash : spr_suplexdash;
						suplexmove = true;
						particle_set_scale(part.jumpdust, xscale, 1);
						create_particle(x, y, part.jumpdust, 0);
						fmod_event_instance_play(suplexdashsnd);
						state = states.handstandjump;
						image_index = 0;
					}
				}
				break;
			
			case 2: // tumble
				var swapdir = key_left + key_right;
				if swapdir != 0
					xscale = swapdir;
				
				movespeed = max(movespeed, grounded ? 7 : 9);
				if movespeed < 24
					movespeed += 1;
				if !grounded
					vsp = -5;
				
				image_index = 0;
				sprite_index = spr_faceplant;
				
				state = states.faceplant;
				image_speed = 0.5;
				
				if obj_player1.character == "N"
					sound_play_3d(sfx_spin, x, y);
				
				particle_set_scale(part.jumpdust, xscale, 1);
				create_particle(x, y, part.jumpdust);
				
				particle_set_scale(part.crazyrunothereffect, xscale, 1);
				create_particle(x, y, part.crazyrunothereffect);
				break;
			
			case 3: // chainsaw
				if floor(global.fuel) > 0
				{
					fmod_event_instance_play(suplexdashsnd);
					
					var swapdir = key_left + key_right;
					if swapdir != 0
						xscale = swapdir;
					
					particle_set_scale(part.jumpdust, xscale, 1);
					create_particle(x, y, part.jumpdust, 0);
					
					particle_set_scale(part.crazyrunothereffect, xscale, 1);
					create_particle(x, y, part.crazyrunothereffect);
					
					with instance_create(x, y, obj_superdashcloud)
						copy_player_scale;
					
					global.fuel = floor(global.fuel - 1);
					state = states.chainsawbump;
					movespeed = max(movespeed, 10);
					sprite_index = spr_chainsawdash;
					image_index = 0;
					
					if global.hud == 1
					{
						with obj_tv
						{
							alarm[0] = 100;
							tvsprite = spr_tvchainsaw;
							image_index = 0;
							image_speed = 0.35;
						}
					}
				}
				break;
		}
	}
	if move == moves.shootattack
	{
		switch shootstyle
		{
			case 2: // breakdance
				sound_play_3d(sfx_breakdance, x, y);
				if !grounded
					vsp = -4;
				else
				{
					with instance_create(x, y, obj_dashcloud2)
						copy_player_scale;
				}
				movespeed = max(movespeed, 9);
				state = states.punch;
				sprite_index = spr_breakdancemove;
				breakdance = 35;
				image_index = 0;
				break;
		}
	}
}
