image_speed = 0.35;
playerid = noone;

spr_idle = spr_pizzaportal;
spr_enter = spr_pizzaportalend;
spr_outline = spr_pizzaportal_outline;

if scr_isnoise(obj_player1)
	spr_enter = spr_pizzaportalendN;

sugary = SUGARY;
if sugary
{
	spr_idle = spr_lappingportal_idle;
	spr_enter = spr_lappingportal_enter;
}
sprite_index = spr_idle;
ID = id;
