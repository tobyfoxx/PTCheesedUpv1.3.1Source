with (other)
{
	if (shotgunAnim)
	{
		shotgunAnim = false;
		sound_play_3d("event:/sfx/misc/detransfo", x, y);
		with (instance_create(x, y, obj_sausageman_dead))
		{
			sprite_index = spr_shotgunback;
			if (scr_isnoise(obj_player1))
				sprite_index = spr_minigunfall;
		}
	}
}
