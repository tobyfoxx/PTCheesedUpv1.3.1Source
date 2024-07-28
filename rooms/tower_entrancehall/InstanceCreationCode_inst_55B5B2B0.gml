if !MOD.CTOPLaps
{
	instance_destroy(id, false);
	instance_destroy(obj_secretbigblock, false);
	with instance_create(x, y, obj_solid)
	{
		image_xscale = 2;
		image_yscale = 2;
	}
}
