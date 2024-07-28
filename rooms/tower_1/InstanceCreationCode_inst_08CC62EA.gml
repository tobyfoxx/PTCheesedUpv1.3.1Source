refresh_func = function()
{
	if obj_player1.character == "P"
		text = lang_get_value_granny("garbage2");
	else if obj_player1.character == "N"
		text = lang_get_value_granny("garbage2N");
	else
		text = embed_value_string(lang_get_value_granny("garbage2X"), [scr_charactername(obj_player1.character, obj_player1.isgustavo)]);
}
refresh_func();
