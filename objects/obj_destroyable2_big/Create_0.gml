event_inherited();
depth = 1;
content = obj_null;
particlespr = -1;
spr_dead = spr_bigpizzablockdead;

if check_char("SP")
{
	sprite_index = spr_candybigbreakable;
	spr_dead = spr_bigcandyblockdead;
	
	if global.blockstyle == blockstyles.old
	{
		// old
		sprite_index = spr_bigbreakableSP_old;
		particlespr = spr_bigcandydebris;
	}
}
else if check_char("BN")
{
	sprite_index = spr_bigbreakable_bo;
	spr_dead = spr_bigpizzablockdead_bo;
}
else if global.blockstyle == blockstyles.old
{
	// old
	sprite_index = spr_bigbreakable_old;
	particlespr = spr_bigpizzadebris;
	spr_dead = -1;
}
