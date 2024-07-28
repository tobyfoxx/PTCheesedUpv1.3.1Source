if array_contains(base_game_levels(), global.leveltosave) && !global.sandbox
{
	ini_open_from_string(obj_savesystem.ini_str);
	if ini_read_real("Highscore", global.leveltosave, 0) == 0 && !ini_read_real("Tutorial", "lapunlocked", false)
		sprite_index = spr_outline;
	ini_close();
}
if global.lapmode != lapmode.laphell && MOD.DeathMode
	instance_destroy();
if global.lapmode == lapmode.laphell && global.laps >= 3
	instance_destroy();
if global.lapmode == lapmode.normal && global.lap
	instance_destroy();
if global.snickchallenge
	instance_destroy();
