event_inherited();

sprite_index = spr_rattumbleblock;
spr_dead = spr_rattumbleblock_dead;
deadsnd = "event:/sfx/rat/ratbowling";

if check_char(["V", "G"])
	instance_change(obj_collect, true);
