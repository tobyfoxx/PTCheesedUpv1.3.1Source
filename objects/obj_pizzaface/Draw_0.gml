if flash
	draw_set_flash();
draw_sprite_ext(sprite_index, image_index, x + offsetx, y + offsety, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_reset_flash();
