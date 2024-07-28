function scr_screenclear()
{
	var c = 0;
	var lag = 20;
	with (obj_baddie)
	{
		if (point_in_camera(x, y, view_camera[0]) && supertauntable)
		{
			global.style += (5 + floor(global.combo / 5));
			
			hp = -99;
			scr_hitstun_enemy(id, lag);
			
			if (elite)
			{
				elitehit = -1;
				mach3destroy = true;
			}
			if (destroyable)
				c++;
			instance_create(x, y, obj_parryeffect);
			repeat 3
			{
				create_slapstar(x, y);
				create_baddiegibs(x, y);
			}
		}
	}
	shake_camera(10, 30 / room_speed);
}