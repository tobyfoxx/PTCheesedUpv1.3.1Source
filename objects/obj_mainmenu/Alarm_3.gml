with instance_create(x, y, obj_sausageman_dead)
{
	sprite_index = spr_titlepep_punch;
	image_speed = 0;
	image_index = irandom(sprite_get_number(sprite_index) - 1);
	if other.currentselect != -1
	{
		var pal = 1, tex = noone;
		if other.game.character == "P" or other.game.character == "G"
		{
			var pal = other.game.palette;
			var tex = other.game.palettetexture;
		}
		
		use_palette = true;
		spr_palette = spr_peppalette;
		paletteselect = pal;
		oldpalettetexture = tex;
	}
}
pep_debris = true;
