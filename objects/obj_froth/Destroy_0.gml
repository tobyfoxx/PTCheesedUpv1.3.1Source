if !in_baddieroom()
{
	with instance_create(x, y, obj_parryeffect)
		sprite_index = spr_snowcloudhit;
}
event_inherited();
