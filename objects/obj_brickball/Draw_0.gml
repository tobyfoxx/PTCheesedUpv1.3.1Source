if scr_ispeppino(obj_player1)
{
	pal_swap_player_palette(,,,,, true);
	draw_self();
	pal_swap_reset();
}
else
	draw_self();
