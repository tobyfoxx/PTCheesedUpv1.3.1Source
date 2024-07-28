enum holiday
{
	none,
	halloween
	
	// further entries are never used and I'm not gonna guess
}

function is_holiday(holiday)
{
	var hl = global.holiday;
	if global.holidayoverride != -1
		hl = global.holidayoverride;
	
	if hl != holiday
		return false;
	if global.sandbox
		return true;
	
	for (var i = 0; i < 3; i++)
	{
		if global.game[i].judgement != "none"
			return true;
	}
	return false;
}
