refresh_func = function()
{
	if obj_player1.isgustavo
		text = lang_get_value_granny("garbage5G");
	else if scr_isnoise()
		text = lang_get_value_granny("garbage5N");
	else
		text = lang_get_value_granny("garbage5");
}
refresh_func();
