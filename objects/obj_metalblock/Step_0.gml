with (obj_player1)
{
	if ((place_meeting(x + hsp, y, other) || place_meeting(x + xscale, y, other))
	&& (state == states.mach3 || (ghostdash == 1 && ghostpepper >= 3) || ratmount_movespeed >= 12
	|| state == states.rocket || state == states.knightpepslopes || state == states.shoulderbash
	or (check_sugarychar() && sprite_index == spr_machroll && abs(hsp) >= 12)
	or (state == states.slipbanan && SUGARY) or (abs(movespeed) >= 16 && character == "S" && (state == states.normal or state == states.jump or state == states.machroll))
	or sprite_index == spr_buttattack or sprite_index == spr_buttattackstart
	or (state == states.twirl && movespeed >= 12)))
	{
		if character == "V"
			instance_create(x, y, obj_dynamiteexplosion);
		
		playerindex = 0;
		with other
		{
			particle_hsp(other);
			instance_destroy();
		}
	}
}
if (place_meeting(x, y + 1, obj_player1) || place_meeting(x, y - 1, obj_player1) || place_meeting(x - 1, y, obj_player1) || place_meeting(x + 1, y, obj_player1))
{
	if (obj_player1.ghostdash == 1 && obj_player1.ghostpepper >= 3)
	{
		particle_momentum();
		instance_destroy();
	}
	if (place_meeting(x, y - 1, obj_player1) && ((obj_player1.state == states.freefall || obj_player1.state == states.superslam) && obj_player1.freefallsmash >= 10))
	{
		with (instance_place(x, y - 1, obj_player1))
		{
			if (character == "M")
			{
				state = states.jump;
				vsp = -7;
				sprite_index = spr_jump;
			}
		}
		
		playerindex = 0;
		particle_vsp();
		instance_destroy();
	}
	if (place_meeting(x, y - 1, obj_player1) && (((obj_player1.state == states.ratmountbounce || obj_player1.state == states.noisecrusher) && obj_player1.vsp > 0) || obj_player1.state == states.knightpep || obj_player1.state == states.hookshot))
	{
		playerindex = 0;
		particle_vsp();
		instance_destroy();
	}
	
	if SUGARY
	{
		if place_meeting(x, y + 1, obj_player1) && obj_player1.state == states.Sjump
		{
			playerindex = 0;
			particle_vsp();
			instance_destroy();
		}
	}
}
