msg = "Midway";
targetRoom = midway_1;
level = "midway";

sprite_index = spr_gate_midway;
bgsprite = spr_gate_midwayBG;
title_index = 4;
title_sprite = spr_titlecards_newtitles;
titlecard_index = 4;
titlecard_sprite = spr_titlecards_new;

title_music = "event:/modded/level/midwaytitle";
group_arr = ["midwaygroup"];

if !BO_NOISE
	instance_destroy();
