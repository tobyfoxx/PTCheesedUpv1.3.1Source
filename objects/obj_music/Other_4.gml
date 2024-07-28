if global.jukebox != noone
	exit;
if MOD.DeathMode or instance_exists(obj_cyop_loader)
	music = noone;
warstart = false;

var fucker = (global.panic && global.leveltosave != "dragonlair" && global.leveltosave != "grinch" && global.leveltosave != "sucrose" && global.leveltosave != "war"
&& (global.leveltosave != "freezer" or !REMIX or global.lap))
or ((global.snickchallenge or MOD.DeathMode) && !instance_exists(obj_titlecard));

if !fucker
{
	var mu = ds_map_find_value(music_map, room);
	if mu == undefined && cached_music != noone
		mu = cached_music;
	
	cached_music = noone;
	if is_struct(mu ?? noone)
	{
		var prevmusic = music;
		if (prevmusic == noone || mu.event_name != prevmusic.event_name)
		{
			fmod_event_instance_play(mu.event);
			fmod_event_instance_set_paused(mu.event, false);
			if (mu.continuous && prevmusic != noone)
			{
				var pos = fmod_event_instance_get_timeline_pos(prevmusic.event);
				pos = music_get_pos_wrap(pos, fmod_event_get_length(mu.event_name));
				fmod_event_instance_set_timeline_pos(mu.event, pos);
			}
			if (prevmusic != noone)
			{
				fmod_event_instance_stop(prevmusic.event, room != Mainmenu);
				if (prevmusic.event_secret != noone)
					fmod_event_instance_stop(prevmusic.event_secret, true);
			}
			music = mu;
			savedmusicpos = 0;
			if (room == war_1 || room == tower_finalhallway)
				fmod_event_instance_stop(music.event, true);
		}
	}
	if (instance_exists(obj_hungrypillar))
	{
		fmod_event_instance_play(pillarmusicID);
		fmod_set_parameter("pillarfade", 0, true);
	}
	else
		fmod_event_instance_stop(pillarmusicID, true);
	
	if music != noone
	{
		if secret && instance_exists(obj_player1)
		{
			var s = 0;
			switch obj_player1.character
			{
				case "SP": case "SN": s = 1; break;
				case "BN": s = 2; break;
			}
			fmod_event_instance_set_parameter(music.event_secret, "state", s, true);
		}
		if music.on_room_start != noone
			music.on_room_start(room, music.event, music.event_secret);
	}
}	
if (!instance_exists(obj_randomsecret))
{
	if MOD.OldLevels
	{
		secretend = secret;
		secret = instance_exists(obj_secretfound);
	}
	if (secret)
	{
		if (music != noone && music.event_secret != noone)
		{
			var ev = music.event_secret, evname = music.event_secret_name;
			fmod_event_instance_play(ev);
			fmod_event_instance_set_paused(ev, false);
			pos = fmod_event_instance_get_timeline_pos(music.event);
			savedmusicpos = pos;
			pos = music_get_pos_wrap(pos, fmod_event_get_length(evname));
			fmod_event_instance_set_timeline_pos(ev, pos);
			fmod_event_instance_set_paused(music.event, true);
		}
		if fucker
		{
			trace("Pausing panic music: room_start");
			savedpanicpos = fmod_event_instance_get_timeline_pos(panicmusicID) ?? 0;
			fmod_event_instance_set_paused(panicmusicID, true);
		}
	}
	else if (secretend)
	{
		secretend = false;
		if (music != noone)
		{
			fmod_event_instance_stop(music.event_secret, true);
			fmod_event_instance_set_paused(music.event, false);
			if !REMIX
				fmod_event_instance_set_timeline_pos(music.event, savedmusicpos);
		}
		if fucker
		{
			fmod_event_instance_set_timeline_pos(panicmusicID, savedpanicpos);
			savedpanicpos = 0;
			fmod_event_instance_set_paused(panicmusicID, false);
			trace("Resuming panic music: room_start");
			cyop_freemusic();
		}
	}
}
if (room == rank_room || room == boss_pizzaface || room == boss_noise || room == boss_vigilante || room == boss_fakepep || room == boss_pepperman)
{
	if (music != noone)
	{
		fmod_event_instance_stop(music.event, true);
		fmod_event_instance_stop(music.event_secret, true);
	}
	cached_music = noone;
}
