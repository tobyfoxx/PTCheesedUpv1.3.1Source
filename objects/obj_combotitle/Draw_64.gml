if !global.option_hud
	exit;
if global.hud != 0
	exit;

if !REMIX && !sugary
{
	for (var i = 0; i < array_length(afterimages); i++)
	{
		var b = afterimages[i];
		trace($"combo after image {i}: {b[3]}");
		draw_sprite_ext(b[2], b[3], b[0], b[1], image_xscale, image_yscale, image_angle, image_blend, b[4]);
		afterimages[i][4] -= 0.15;
	}
}
scr_combotitledraw(sprite_index, x, y, title, title_index);
