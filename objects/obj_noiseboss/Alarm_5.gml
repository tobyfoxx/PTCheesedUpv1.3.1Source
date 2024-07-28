flash = true;
if (sprite_index != spr_doise_deadair && sprite_index != spr_playerN_animatronic && state != states.fightball && state != states.phase1hurt && state != states.ending && !ballooncrash && (!instance_exists(obj_noiseballooncrash) || scr_isnoise(obj_player1)))
	sound_play_3d("event:/sfx/misc/bossvulnerable", x, y);
