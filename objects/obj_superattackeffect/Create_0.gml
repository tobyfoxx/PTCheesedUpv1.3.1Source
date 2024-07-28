image_speed = 0.1;
x = -sprite_width;
y = 200;
movespeed = 10;

if check_char("V")
	sprite_index = spr_vigi_superattackHUD;
else if scr_isnoise(obj_player1)
	sprite_index = spr_noise_superattackHUD;
