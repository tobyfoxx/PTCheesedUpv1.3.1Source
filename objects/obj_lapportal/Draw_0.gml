if (sprite_index != spr_idle && sprite_index != spr_outline)
{
	pal_swap_player_palette();
	draw_self();
	pal_swap_reset();
}
else if (sprite_index == spr_outline)
	draw_sprite_ext(sprite_index, image_index, x, y + Wave(-2, 2, 1, 5), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
else
{
	draw_self();
	if !sugary
	{
		if !global.lap
			draw_sprite(spr_lap2warning, 0, x, y + Wave(-5, 5, 0.5, 5));
		else if global.lapmode == lapmode.laphell
		{
			var spr_lap3warning = spr_ough_im_getting_egg_like;
			var img = 0;
			
			if global.laps == 1
			{
				img = 1;
				switch obj_player1.character
				{
					case "N": img = 2; break;
					case "V": img = 3; break;
					case "S": img = 4; break;
					case "G": img = 5; break;
					case "SP": img = 6; break;
					case "SN": img = 7; break;
				}
			}
			
			pal_swap_player_palette(spr_lap3warning, img, 1, 1);
			draw_sprite(spr_lap3warning, img, x, y + Wave(-5, 5, 0.5, 5));
			pal_swap_reset();
		}
		else
			draw_sprite(spr_lap2warning, 1, x, y + Wave(-5, 5, 0.5, 5));
	}
}
