live_auto_call;

if !instance_exists(obj_onlineclient)
{
	instance_destroy();
	exit;
}

scr_online_player();

color_array = [1, 2];
switch character
{
	case online_characters.peppino: spr_palette = spr_peppalette; color_array = [1, 2, 3, 4]; break;
	case online_characters.noise: spr_palette = spr_noisepalette; break;
	case online_characters.vigilante: spr_palette = spr_vigipalette; break;
	case online_characters.gustavo: spr_palette = spr_peppalette; break;
	case online_characters.snick: spr_palette = spr_snickpalette; break;
	
	case online_characters.pizzelle: spr_palette = spr_pizzypalette; break;
	case online_characters.pizzano: spr_palette = spr_pizzanopalette; break;
	
	case online_characters.bonoise: spr_palette = spr_bopalette; break;
}
