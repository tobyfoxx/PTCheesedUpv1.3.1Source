function scr_player_freefallland()
{
	mach2 = 0;
	jumpAnim = true;
	dashAnim = true;
	landAnim = false;
	moveAnim = true;
	stopAnim = true;
	crouchslideAnim = true;
	crouchAnim = false;
	machhitAnim = false;
	movespeed = 0;
	facehurt = true;
	start_running = true;
	alarm[4] = 14;
	vsp = 0;
	hsp = 0;
	
	var jump = false;
	if key_jump && global.poundjump
		jump = true;
	else if (floor(image_index) == (image_number - 1))
	{
		if key_jump2 && global.poundjump
			jump = true;
		else
		{
			if character != "S"
			{
				facehurt = true;
				sprite_index = spr_facehurtup;
				image_index = 0;
			}
			state = states.normal;
			jumpstop = true;
		}
	}
	
	if jump
	{
		state = states.jump;
        vsp = -13;
        jumpstop = true;
		scr_fmod_soundeffect(jumpsnd, x, y);
		
		if spr_groundpoundjump != spr_player_groundpoundjump or character == "P"
			sprite_index = spr_groundpoundjump;
		else
			sprite_index = spr_machfreefall;
		
		particle_set_scale(part.highjumpcloud2, xscale, 1);
		create_particle(x, y, part.highjumpcloud2, 0);
	}
	image_speed = 0.35;
}
