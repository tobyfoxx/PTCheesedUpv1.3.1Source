image_blend = c_white;
image_alpha = 1;

// only appear on egg's lap 3
if !(global.laps >= 2 && global.chasekind == 1)
	instance_destroy(id, false);
