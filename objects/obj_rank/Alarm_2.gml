brown = true;
if sugary
{
	brownfade = 1;
	with instance_create(0, 0, obj_flash)
		depth = other.depth - 1;
}
