targetRoom = tower_entrancehall;
targetDoor = "C";

if scr_isnoise() && !global.swapmode
{
	ini_open_from_string(obj_savesystem.ini_str);
	if ini_read_string("Game", "finalrank", "none") != "none" or global.sandbox
	{
		targetRoom = tower_peppinohouse;
		instance_create(0, 0, obj_puff_house);
	}
	ini_close();
}
