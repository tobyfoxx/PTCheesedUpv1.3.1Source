enum SKIN
{
	p_peter,
	n_chungus,
	
	enum_size
}
function check_skin(check, char = obj_player1.character, pal = obj_player1.paletteselect)
{
	switch check
	{
		case SKIN.p_peter: return char == "P" && pal == 55;
		//case SKIN.n_chungus: return char == "N" && pal == 25;
	}
	return false;
}
