function scr_charactername(character, isgustavo)
{
	if character != "N" && character != "V" && isgustavo
		return "Gustavo";
	if character == "V" && isgustavo
		return "Mort";
	
	switch character
	{
		case "P": return "Peppino"; break;
		case "N": return "The Noise"; break;
		case "V": return "Vigilante"; break;
		case "SP": return "Pizzelle"; break;
		case "SN": return "Pizzano"; break;
		case "BN": return "Bo Noise"; break;
		case "S": return "Snick"; break;
		case "M": return "Pepperman"; break;
	}
	return "Yourself";
}
