if (use_static)
	draw_sprite_stretched(spr_tvstatic, static_index, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
else
{
	screen_clear(make_color_rgb(216, 104, 160));
	
	var cx = SCREEN_X;
	var cy = SCREEN_Y;
	
	var bg = spr_technicaldifficulty_bg;
	if chara == "N"
		bg = spr_technicaldifficulty_bgnoise;
	if chara == "V"
		bg = spr_technicaldifficulty_bgV;
	draw_sprite(bg, 0, cx, cy);
	
	pal_swap_player_palette(sprite, 0, 1, 1, , sprite == spr_technicaldifficulty4);
	if chara == "BN" or chara == "SP"
		draw_sprite(sprite, 0, cx, cy);
	else
		draw_sprite(sprite, 0, cx + 300, cy + 352);
	pal_swap_reset();
}
