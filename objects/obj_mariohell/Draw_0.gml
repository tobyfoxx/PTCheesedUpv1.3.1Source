live_auto_call;

draw_clear(c_black);
if con > 0
{
	if irandom(50) == 5 && con >= 5
		draw_sprite_ext(spr_mario, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, random_range(0.75, 1.25), random_range(0.75, 1.25), random_range(-2, 2), merge_colour(c_white, c_red, random_range(0, 0.5)), 1);
	else
		draw_sprite(spr_mario, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
}
