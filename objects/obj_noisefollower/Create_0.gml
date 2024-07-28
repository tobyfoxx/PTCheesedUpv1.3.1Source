event_inherited();
walkspr = spr_playerN_move;
idlespr = spr_playerN_panicidle;
image_speed = 0.35;

if scr_isnoise(obj_player1) || global.swapmode
{
	walkspr = spr_bucket;
	idlespr = spr_bucket;
	sprite_index = spr_bucket;
}
