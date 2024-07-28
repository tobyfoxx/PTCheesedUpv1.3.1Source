if in_baddieroom()
{
	instance_destroy();
	exit;
}

if instance_exists(obj_cyop_loader)
{
	while place_meeting(x, y, obj_solid)
	    y--;
	
	if paletteselect != 0
	{
		basepal = paletteselect;
		elitepal = paletteselect;
	}
}

if (safe_get(id, "escape"))
{
	if (escapespawnID == noone)
	{
		with (instance_create(x, y, obj_escapespawn))
		{
			baddieID = other.id;
			other.escapespawnID = id;
		}
		instance_deactivate_object(id);
	}
}
if (safe_get(id, "elite") && object_index != obj_robot)
{
	hp += 1;
	elitehp = hp;
}
if check_heat() && ((safe_get(id, "elite") && use_elite) or global.stylethreshold >= 3)
	paletteselect = elitepal;

// snap to ground if sugary
if SUGARY
{
	for(var i = 1; i < 32; i++)
	{
		if scr_solid(x, y + i)
		{
			y += i - 1;
			break;
		}
	}
}
