if instance_exists(obj_player1)
{
	if scr_ispeppino(obj_player1) || room == Mainmenu
		fmod_set_parameter("isnoise", 0, true);
	else
		fmod_set_parameter("isnoise", 1, true);
}
fmod_set_parameter("swapmode", global.swapmode ? 1 : 0, true);
