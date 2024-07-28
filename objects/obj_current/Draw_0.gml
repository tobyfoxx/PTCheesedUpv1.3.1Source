if MOD.Encore
{
	shader_set(global.Pal_Shader);
	pal_swap_set(spr_currentpalette, 1);
}
for (var i = 0; i < abs(image_xscale); i++)
	draw_sprite_ext(sprite_index, image_index, x + (sign(image_xscale) * 32 * i), y, sign(image_xscale), sign(image_yscale), 0, c_white, 1);

shader_reset();
