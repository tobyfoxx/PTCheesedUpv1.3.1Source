if instance_exists(obj_savesystem) && obj_savesystem.state != 0
{
	alarm[1] = 1;
	exit;
}

// load textures
var len = array_length(tex_arr);
if len > 0
{
	var tex = array_pop(tex_arr);
	if !texture_is_ready(tex)
	{
		trace("[loadingscreen] Loading texture: ", tex);
		texture_prefetch(tex);
	}
	alarm[1] = 1;
}

// load cyop tower
else if cyop_tower != ""
{
	if !instance_exists(obj_player)
	{
		scr_pause_activate_objects(false);
		alarm[1] = 1;
		exit;
	}
	
	cyop_load_internal(cyop_tower);
	cyop_tower = "";
	alarm[1] = 1;
}

else if cyop_changesave
{
	gamesave_async_load();
	cyop_changesave = false;
	alarm[1] = 1;
}

// load cyop level
else if cyop_level != ""
{
	cyop_load_level_internal(cyop_level, true);
	cyop_level = "";
	alarm[1] = 1;
	
	trace("[loadingscreen] Loaded cyop_level");
}

// done
else
{
	if instance_exists(obj_cyop_assetloader) && obj_cyop_assetloader.wait()
	{
		alarm[1] = 1;
		exit;
	}
	instance_destroy();
}
