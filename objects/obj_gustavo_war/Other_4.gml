if scr_isnoise(obj_player1)
{
	instance_destroy();
	with instance_create(x, y + 12, obj_bucket_war)
		image_xscale = other.image_xscale;
}
