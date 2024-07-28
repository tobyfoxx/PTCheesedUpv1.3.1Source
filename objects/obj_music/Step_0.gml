if global.jukebox != noone
{
	if !fmod_event_instance_is_playing(global.jukebox.instance)
		fmod_event_instance_play(global.jukebox.instance);
	
	if music != noone
	{
		fmod_event_instance_stop(music.event, true);
		fmod_event_instance_release(music.event, true);
	}
	music = noone;
	
	var mu = ds_map_find_value(music_map, room);
	if mu != undefined or room == street_intro
		cached_music = mu ?? noone;
	exit;
}

if waiting && !safe_get(obj_pause, "pause")
{
	waiting = false;
	event_perform(ev_other, ev_room_start);
}
if warstart && !(MOD.DeathMode or global.jukebox != noone) && music != noone
{
	fmod_event_instance_play(music.event);
	warstart = false;
}

prevpillar_on_camera = pillar_on_camera;
if (fmod_event_instance_is_playing(kidspartychaseID) && instance_exists(obj_pause) && !obj_pause.pause && !instance_exists(obj_monster))
{
	trace("Stopping kidsparty music");
	fmod_event_instance_stop(kidspartychaseID, false);
	instance_destroy(obj_kidspartybg);
	if current_custom != noone && instance_exists(obj_cyop_loader)
	{
		var song = custom_music[current_custom];
		if song.fmod
			fmod_event_instance_set_paused(song.instance, savedmusicpause);
		else if !savedmusicpause
			audio_resume_sound(song.instance);
	}
	else if (music != noone)
	{
		fmod_event_instance_set_paused(music.event, savedmusicpause);
		fmod_event_instance_set_paused(music.event_secret, savedsecretpause);
	}
	fmod_event_instance_set_paused(pillarmusicID, savedpillarpause);
	fmod_event_instance_set_paused(panicmusicID, savedpanicpause);
}

// pillarfade
if instance_exists(obj_hungrypillar) && (global.leveltosave != "freezer" or !REMIX)
{
	fmod_event_instance_set_paused(pillarmusicID, false);
	fmod_event_instance_set_parameter(pillarmusicID, "state", SUGARY ? 20 : 0, true);
	
	var p = false;
	with (obj_hungrypillar)
	{
		if (bbox_in_camera(view_camera[0], 0))
			p = true;
	}
	if (p != pillar_on_camera)
		pillar_on_camera = p;
}
else
	pillar_on_camera = false;
if prevpillar_on_camera != pillar_on_camera
	fmod_set_parameter("pillarfade", pillar_on_camera, false);

if !safe_get(obj_pause, "pause") && instance_exists(obj_player1)
{
	if instance_exists(obj_cyop_loader) && secret
		cyop_music();
	else if (global.panic && global.leveltosave != "dragonlair" && global.leveltosave != "grinch" && global.leveltosave != "sucrose"
	&& (global.leveltosave != "freezer" or !REMIX or global.lap))
	or ((global.snickchallenge or MOD.DeathMode) && !instance_exists(obj_titlecard))
	{
		if !panicstart
		{
			destroy_sounds([panicmusicID]);
			
			if global.snickchallenge
			{
				if global.snickrematch 
					panicmusicID = fmod_event_create_instance("event:/modded/level/snickrematch");
				else
					panicmusicID = fmod_event_create_instance("event:/modded/level/snickchallenge");
			}
			else if MOD.DeathMode && DEATH_MODE
				panicmusicID = fmod_event_create_instance("event:/modded/deathmode");
			else if room == tower_finalhallway or global.leveltosave == "exit"
				panicmusicID = fmod_event_create_instance("event:/music/finalescape");
			else
			{
				var char = obj_player1.character;
				switch char
				{
					case "P": case "G": panicmusicID = fmod_event_create_instance("event:/music/pizzatime"); break;
					case "N": panicmusicID = fmod_event_create_instance("event:/music/pizzatimenoise"); break;
					default:
						panicmusicID = fmod_event_create_instance($"event:/music/pizzatime{obj_player1.character}");
						break;
				}
			}
			cyop_freemusic();
			
			trace("Starting panic music: step");
			panicstart = true;
			
			fmod_event_instance_play(panicmusicID);
			fmod_event_instance_set_paused(panicmusicID, false);
			fmod_event_instance_set_parameter(panicmusicID, "state", 0, true);
				
			if music != noone
			{
				fmod_event_instance_stop(music.event, true);
				fmod_event_instance_stop(music.event_secret, true);
			}
			
			if instance_exists(obj_hungrypillar)
			{
				fmod_event_instance_stop(pillarmusicID, true);
				fmod_set_parameter("pillarfade", 0, true);
				fmod_event_instance_set_parameter(panicmusicID, "state", 0, true);
			}
		}
		else if fmod_event_instance_is_playing(panicmusicID)
		{
			if !global.lap
			{
				var secs = 56;
				if fmod_get_parameter("isnoise", true) >= 1
					secs = 65;
				if global.fill <= secs * 12
					fmod_event_instance_set_parameter(panicmusicID, "state", 1, true);
			}
			else
			{
				if global.lapmode == lapmode.laphell && global.laps >= 2 // pillar john's revenge
					fmod_event_instance_set_parameter(panicmusicID, "state", 20, true);
				else if global.laps >= 4 // blue licorice
					fmod_event_instance_set_parameter(panicmusicID, "state", 3, true);
				else // the death that I deservioli
					fmod_event_instance_set_parameter(panicmusicID, "state", 2, true);
			}
		}
	}
	else
	{
		panicstart = false;
		fmod_event_instance_stop(panicmusicID, true);
	
		if instance_exists(obj_player)
		{
			if instance_exists(obj_cyop_loader)
				cyop_music();
			else
				cyop_freemusic();
		}
	}
}

// lower music volume for sfx
var _found = false;
with (obj_totem)
{
	if (fmod_event_instance_is_playing(snd) && distance_to_object(obj_player1) <= 400)
		_found = true;
}
with (obj_player)
{
	if (state == states.gottreasure)
		_found = true;
}
with (obj_pumpkin)
{
	if !trickytreat
	{
		if (distance_to_object(obj_player1) <= soundradius)
			_found = true;
	}
}
if (_found)
	fmod_set_parameter("totem", 1, false);
else
{
	fmod_set_parameter("totem", 0, false);
	if (instance_exists(obj_bossdark))
		fmod_set_parameter("totem", 1, false);
	if (instance_exists(obj_charswitch_intro))
		fmod_set_parameter("totem", 2, false);
}

// taxi music muffle in CYOP
audio_bus_main.effects[0].bypass = fmod_get_parameter("musicmuffle", false) < .5;

// riding weenie in FFS or CTOP
if instance_exists(obj_player) && REMIX
	fmod_set_parameter("weenie", obj_player1.state == states.rideweenie, false);
else
	fmod_set_parameter("weenie", 0, false);
