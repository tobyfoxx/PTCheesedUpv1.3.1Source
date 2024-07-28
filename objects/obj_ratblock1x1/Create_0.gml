event_inherited();

sprite_index = spr_ratblock6;
spr_dead = spr_ratblock6_dead;

if MIDWAY
{
	sprite_index = spr_ratblock6_bo;
	spr_dead = spr_ratblock6_dead_bo;
}
if sugary
{
	sprite_index = spr_chocofrogsmall;
	spr_dead = spr_chocofrogsmalldead;
}

if check_char(["V", "G"])
	instance_change(obj_collect, true);
