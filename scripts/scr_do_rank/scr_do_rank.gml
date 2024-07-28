function scr_is_p_rank()
{
	var enemykilled = global.prank_enemykilled or MOD.Pacifist or MOD.FromTheTop;
	var lap = global.lap or MOD.FromTheTop;
	
	if global.leveltosave == "dragonlair" or global.leveltosave == "grinch"
		return !global.combodropped && enemykilled;
	if global.leveltosave == "etb"
		return !global.combodropped && global.secretfound >= 2 && (global.lap or MOD.DeathMode);
	if global.leveltosave == "snickchallenge"
		return !global.combodropped && !string_starts_with(room_get_name(room), "medieval");
	
	if MOD.OldLevels
		return global.secretfound >= 6 && global.treasure && !global.combodropped && enemykilled;
	else if (global.leveltosave != "exit" && global.leveltosave != "secretworld") && !MOD.DeathMode
		return lap && global.secretfound >= 3 && global.treasure && !global.combodropped && enemykilled;
	else if DEATH_MODE && MOD.DeathMode
		return global.secretfound >= 3 && global.treasure && !global.combodropped && enemykilled && global.shroomfollow && global.cheesefollow && global.tomatofollow && global.sausagefollow && global.pineapplefollow;
	else if (global.leveltosave == "exit")
		return !global.combodropped;
	else
		return !global.combodropped && enemykilled;
}
function scr_do_rank(showtoppins = true, boss = false)
{
	fmod_event_instance_stop(global.snd_escaperumble, true);
	var ex = x;
	var ey = y;
	var cx = camera_get_view_x(view_camera[0]) + SCREEN_X;
	var cy = camera_get_view_y(view_camera[0]) + SCREEN_Y;
	rankpos_x = ex - cx;
	rankpos_y = ey - cy;
	if (global.timeattack == 1)
		obj_timeattack.stop = true;
	with (obj_wartimer)
		notification_push(notifs.wartimer_endlevel, [minutes, seconds + addseconds]);
	targetDoor = "none";
	obj_camera.alarm[2] = -1;
	
	var leveltosave = global.leveltosave;
	if instance_exists(obj_cyop_loader)
		leveltosave = string_replace(leveltosave, "cyop_", "");
	
	if (!global.tutorial_room)
	{
		if (!boss)
			scr_savescore(leveltosave);
		else
		{
			ini_open_from_string(obj_savesystem.ini_str);
			
			var _hats = global.hats;
			if (ini_read_real("Hats", leveltosave, 0) < _hats)
				ini_write_real("Hats", leveltosave, _hats);
			
			var _extrahats = global.extrahats;
			if (ini_read_real("Extrahats", leveltosave, 0) < _extrahats)
				ini_write_real("Extrahats", leveltosave, _extrahats);
			
			var _rank = "d";
			var maxhats = 6 + global.srank;
			var currhats = _extrahats + _hats;
			
			if (currhats >= maxhats && !global.bossplayerhurt)
				_rank = "p";
			else if (currhats >= (maxhats - 2))
				_rank = "s";
			else if (currhats >= (maxhats - 4))
				_rank = "a";
			else if (currhats >= (maxhats - 6))
				_rank = "b";
			else if (currhats >= (maxhats - 8))
				_rank = "c";
			
			global.rank = _rank;
			scr_write_rank(leveltosave);
			scr_play_rank_music();
			obj_savesystem.ini_str = ini_close();
			gamesave_async_save();
		}
		notification_push(notifs.end_level, [global.leveltosave, global.secretfound, global.level_minutes, global.level_seconds]);
		with (obj_achievementtracker)
			event_perform(ev_step, ev_step_normal);
	}
	else
	{
		var _lap = false;
		
		ini_open_from_string(obj_savesystem.ini_str);
		ini_write_real("Tutorial", "finished", true);
		
		if (global.level_minutes < 2 || (global.level_minutes < 1 || (global.level_minutes == 1 && global.level_seconds <= 40)))
		&& ini_read_real("Tutorial", "lapunlocked", false) == false
		{
			ini_write_real("Tutorial", "lapunlocked", true);
			_lap = true;
		}
		obj_savesystem.ini_str = ini_close();
		
		if _lap && !global.sandbox
			create_transformation_tip(lang_get_value("tutorial_lapunlock"));
	}
	if (global.combo > 0)
	{
		global.combotime = 0;
		global.combo = 0;
		with obj_camera
		{
			spr_palette = noone;
			paletteselect = 0;
			
			alarm[4] = -1;
			for (var i = 0; i < min(global.comboscore, 500); i += 10)
			{
				var spr = scr_collectspr(obj_collect, , false);
				create_collect(obj_player1.x + irandom_range(-60, 60), obj_player1.y - 100 + irandom_range(-60, 60), spr, 10, spr_palette, paletteselect);
			}
		}
		global.comboscore = 0;
	}
	if (!instance_exists(obj_endlevelfade))
	{
		with (instance_create(x, y, obj_endlevelfade))
		{
			do_rank = true;
			toppinvisible = showtoppins;
			with (obj_pizzaface)
			{
				if (bbox_in_camera(view_camera[0]))
					notification_push(notifs.close_call, []);
			}
			if (global.leveltosave == "tutorial")
			{
				do_rank = false;
				targetRoom = tower_entrancehall;
				targetDoor = "HUB";
			}
			else if (global.leveltosave == "secretworld")
				toppinvisible = false;
			else if (room == tower_entrancehall)
			{
				with (obj_followcharacter)
					persistent = false;
				if (!global.exitrank)
				{
					do_rank = false;
					targetRoom = Endingroom;
					targetDoor = "A";
					instance_destroy(obj_pigtotal);
					stop_music();
					fmod_event_instance_stop(global.snd_rank, true);
					sound_play("event:/sfx/ending/towercollapsetrack");
				}
				else
					toppinvisible = false;
			}
		}
	}
	with obj_player
	{
		state = states.door;
		sprite_index = isgustavo ? spr_ratmountenterdoor : spr_lookdoor;
	}
	obj_endlevelfade.alarm[0] = 235;
	if REMIX
		obj_endlevelfade.alarm[0] = 230;
	if check_sugarychar()
		obj_endlevelfade.alarm[0] = 190;
	image_index = 0;
	global.panic = false;
	global.snickchallenge = false;
	global.leveltorestart = noone;
	gamesave_async_save();
}
