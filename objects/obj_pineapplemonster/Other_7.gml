if (!fadeout)
{
	image_speed = 0;
	image_index = image_number - 1;
	fadeout = true;
	if (monster)
		scr_monster_activate();
	if (content != noone)
	{
		if (content == obj_bazooka)
			content = obj_pineappleprojectilespawn;
		with (instance_create(x, y, content))
		{
			create_particle(x, y, part.genericpoofeffect);
			if (object_index == obj_bazooka)
			{
				sound_play_3d("event:/sfx/enemies/piranha", x, y);
				sprite_index = spr_piraneapple_projectile;
				destroy = false;
			}
		}
	}
}
