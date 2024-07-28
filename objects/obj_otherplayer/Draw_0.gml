live_auto_call;

if room == rank_room or room == timesuproom or room == Endingroom or room == Creditsroom or room == Johnresurrectionroom or room == characterselect
or room == boss_pizzafacefinale
	exit;

var spr = sprite_exists(sprite_index) ? sprite_index : spr_noise_vulnerable1loop;
var xx = lerp(x, xprevious, 0.5), yy = lerp(y, yprevious, 0.5);

if --flash > 0
	draw_set_flash();
else
{
	shader_set(global.Pal_Shader);
	pattern_set_temp(color_array, spr, image_index, image_xscale, image_yscale, pattern, global.Pattern_Index);
	pal_swap_set(spr_palette, paletteselect);
}

draw_sprite_ext(spr, image_index, xx, yy, image_xscale, image_yscale, image_angle, image_blend, image_alpha * global.online_opacity);

if flash > 0
	draw_reset_flash();
else
	pal_swap_reset();

draw_online_name(xx, yy, sprite_index, username);