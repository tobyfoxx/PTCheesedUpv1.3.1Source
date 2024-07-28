/// @description switch characters
var stick = false, sugary = check_sugary();
if global.leveltosave == "forest" || global.leveltosave == "street"
	stick = true;
else if irandom(100) <= 15
	stick = true;

if scr_ispeppino(obj_player1) && !global.swapmode
{
	var r = string_letters(room_get_name(room));
	if sprite_index != spr_gustavo_exitsign || r == "saloon" || room == space_11b || r == "freezer" || r == "chateau" || r == "floor5"
		stick = false;
}
else
{
	spr_fall = spr_noiseyexit_fall;
	spr_idle = spr_noiseyexit_idle;
}

if check_char("G") && !sugary
	stick = true;
if stick
{
	if sugary
	{
		// sugary polka
		spr_fall = spr_polka_fall;
		spr_idle = spr_polka_exit;
		spr_taunt = spr_polka_taunt;
	}
	else
	{
		// mr stick
		ystart -= 6;
		
		spr_fall = spr_stick_fall;
		spr_idle = spr_stick_exit;
		
		if scr_isnoise(obj_player1) || global.swapmode
		{
			spr_fall = spr_noisette_fall;
			spr_idle = spr_noisette_exit;
			spr_taunt = spr_noisette_ass;
		}
	}
}
else if sugary
{
	// sugary rosette
	spr_fall = spr_rosette_fall;
	spr_idle = spr_rosette_exit;
	spr_taunt = spr_rosette_cheer;
	spr_dull = spr_rosette_dull;
}
