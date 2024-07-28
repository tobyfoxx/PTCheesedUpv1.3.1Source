function scr_player_finishingblow()
{
	if character == "SP"
		suplexmove = false;
	
	if IT_FINAL
	{
		hsp = movespeed;
		move = key_right + key_left;
		if (floor(image_index) < 4 && sprite_index != spr_swingdingend)
			movespeed = Approach(movespeed, 0, 1);
		else
			movespeed = Approach(movespeed, -xscale * 4, 0.5);
	}
	else
	{
		hsp = 0;
		vsp = 0;
	}
	
	if (floor(image_index) == (image_number - 1))
	{
		if IT_FINAL
		{
			movespeed = 0;
			railmovespeed = 4;
			raildir = -xscale;
		}
		state = states.normal;
	}
	if (floor(image_index) == 0 && !instance_exists(obj_swordhitbox))
	{
		with (instance_create(x, y, obj_swordhitbox))
			playerid = other.object_index;
	}
	
	image_speed = 0.4;
	landAnim = false;
	
	if IT_FINAL
	{
		if (!instance_exists(obj_dashcloud2) && grounded && movespeed > 3)
		{
			with (instance_create(x, y, obj_dashcloud2))
				copy_player_scale;
		}
		
		if (punch_afterimage > 0)
			punch_afterimage--;
		else
		{
			punch_afterimage = 5;
			with (create_blue_afterimage(x, y, sprite_index, image_index, xscale))
			{
				playerid = other.id;
				maxmovespeed = 6;
			}
		}
	}
}
