/// @description lap 4 temp time
if !(global.laps == 2 && global.lapmode == lapmode.laphell)
	exit;

global.lap4time++;
alarm[0] = 60;
