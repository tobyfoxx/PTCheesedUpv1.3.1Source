if (distance_to_object(obj_player1) < 250)
	sprite_index = spr_noisevengeful1;
else
	sprite_index = spr_noisevengeful2;
if (scr_isnoise(obj_player1) || global.swapmode)
	sprite_index = spr_bucket;
