function scr_ispeppino(obj = self)
{
	var char = safe_get(obj, "character") ?? obj_player1.character;
	return char != "N";
}

function scr_isnoise(obj = self)
{
	var char = safe_get(obj, "character") ?? obj_player1.character;
	return char == "N";
}
