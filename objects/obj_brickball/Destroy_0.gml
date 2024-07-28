if (scr_ispeppino(obj_player1))
{
	with (instance_create(x, y, obj_brickcomeback))
	{
		vsp = -5;
		hsp = -sign(other.hsp) * 4;
	}
}
else
{
	with (create_debris(x, y, spr_lonebrick_comeback, true))
	{
		hsp = -other.image_xscale * 4;
		image_speed = 0.4;
	}
}
shake_camera(10, 30 / room_speed);
repeat (3)
{
	with (create_debris(x, y, spr_slapstar))
	{
		hsp = random_range(-5, 5);
		vsp = random_range(-10, 10);
	}
}
with (obj_baddie)
	rattime = 0;
sound_play_3d("event:/sfx/pep/groundpound", x, y);
instance_create(x, y, obj_bangeffect);
if (instance_exists(obj_brickballspeedline))
	instance_destroy(obj_brickballspeedline);
