event_inherited();
image_speed = 0.35;
yoffset = 0;
do_end = false;
hsp = 0;
vsp = 0;
grav = 0.5;
movespeed = 3;
state = states.normal;
tauntID = noone;
playerid = obj_player1;
if SUGARY
{
	collectedspr = spr_gerome_collected_ss
	idlespr = spr_gerome_idle_ss
	movespr = spr_gerome_keymove_ss
	tauntspr = spr_gerome_taunt
}
else
{
	collectedspr = spr_gerome_collected
	idlespr = spr_gerome_keyidle
	movespr = spr_gerome_keymove
	tauntspr = spr_gerome_taunt
}
sprite_index = collectedspr
