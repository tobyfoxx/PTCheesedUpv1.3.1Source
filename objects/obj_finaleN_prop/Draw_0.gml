if !tiled
{
	if !usepalette
		draw_self();
	else
	{
		shader_set(global.Pal_Shader);
		pattern_set(global.Base_Pattern_Color, sprite_index, image_index, image_xscale, image_yscale, global.palettetexture);
		pal_swap_set(spr_palette, paletteselect, false);
		draw_self();
		pattern_reset();
		shader_reset();
	}
	if flash
	{
		draw_set_flash();
		draw_self();
		draw_reset_flash();
	}
}
else
	draw_sprite_tiled(sprite_index, image_index, x, y);
