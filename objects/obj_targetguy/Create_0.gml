init_collision();
flash = false;
flashbuffer = 0;
bullethit = 3;
bounce = 0;
image_speed = 0;
image_index = choose(0, 1);
depth = 0;

snotty = check_char("V");
if snotty
	sprite_index = spr_targetguys_snotty;
