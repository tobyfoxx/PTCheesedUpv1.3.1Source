if (delay > 0)
	delay--;
else
{
	delay = delaymax;
	pos++;
	
	if !is_array(objectlist)
	{
		if asset_get_type(objectlist) == asset_object// or is_real(objectlist)
			objectlist = [objectlist];
		else
		{
			repeat 5
				show_message($"{id} objectlist is not array\nblame beebawp also screenshot this\n\n{objectlist}");
			instance_destroy();
			exit;
		}
	}
	
	if (pos >= array_length(objectlist))
		pos = 0;
	with (instance_create(x, y - 32, objectlist[pos]))
	{
		repeat (4)
			instance_create(x, y, obj_factorycreateeffect);
		switch (object_index)
		{
			case obj_dashpad:
				image_xscale = other.dir;
				break;
			case obj_superspring:
				use_collision = true;
				break;
			case obj_pinballlauncher:
				use_collision = true;
				break;
		}
	}
}
