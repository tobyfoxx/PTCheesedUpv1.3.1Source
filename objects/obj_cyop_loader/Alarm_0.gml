/// @description create layers

live_auto_call;
ds_list_clear(global.cyop_broken_tiles);

// clean up
with obj_persistent
{
	room_tiles = [];
	room_bgs = [];
}

try
{
	// add instances
	var _room = global.cyop_rooms[room_ind][1];
	
	var prop = _room.properties;
	for(var i = 0, n = array_length(_room.instances); i < n; ++i)
	{
		var inst_data = _room.instances[i];
		if inst_data.deleted
			continue;
		
		var layer_name = $"Instances_{inst_data.layer}";
		if !layer_exists(layer_name)
			var lay = layer_create(-1 - inst_data.layer, layer_name);
		else
			lay = layer_get_id(layer_name);
		
		// figure out object
		if inst_data.object >= array_length(objects)
			return cyop_error_exit("This tower is incompatible, because it was probably made using a mod that adds extra objects.\n\nSuggest fixing this in a forum post or something.");
		var asset_name = objects[inst_data.object], asset = asset_name;
		switch asset
		{
			case "obj_teleporter_receptor": asset = obj_teleporter; break;
			case "obj_pizzasona_spawn": asset = obj_bigcollect; break;
			case "obj_warp_number": asset = obj_doorX; break;
			case "obj_bigcollectarena": asset = obj_bigcollect; break;
			case "obj_collectarena": asset = obj_collect; break;
			case "obj_roomname":
				global.roommessage = inst_data.variables[$ "msg"];
				continue;
			default:
				if is_string(asset)
				{
					trace("levelLoader - ", asset_name, " disallowed");
					return cyop_error_exit($"This tower is incompatible, because it uses one of those CYOP fixed objects mods.\nAFOM object name: \"{asset_name}\"\n\nThis is being worked on.");
				}
		}
		
		// add instance
		var inst = instance_create_layer(floor(inst_data.variables.x - prop.roomX), floor(inst_data.variables.y - prop.roomY), lay, asset);
		if instance_exists(inst) // sometimes it fucking doesn't
		{
			inst.targetRoom = "main";
			switch asset_name
			{
				case obj_teleporter:
					inst.start = true;
					break;
				
				case "obj_pizzasona_spawn":
					if in_saveroom(inst)
						break;
					
					inst.visible = false;
					inst.value = 150;
				
					with instance_create(inst.x, inst.y - 42, obj_pizzasonacollect)
						collectID = inst.id;
					break;
				
				case "obj_collectarena":
				case "obj_bigcollectarena":
					inst.arena = true;
					break;
			}
		
			var struct = inst_data.variables;
			var varNames = variable_struct_get_names(struct);
			
			for (var j = 0; j < array_length(varNames); j++)
			{
				if varNames[j] == "useLayerDepth" && struct[$ varNames[j]]
					inst.depth = -inst_data.layer;
				else if varNames[j] == "trigger" && asset == obj_doorX
					inst.door = struct.trigger;
			    else if varNames[j] != "x" && varNames[j] != "y" && varNames[j] != "cyop"
					inst[$ varNames[j]] = cyop_resolvevalue(struct[$ varNames[j]], varNames[j]);
			}
			
			// level name
			if (object_index == obj_startgate or object_index == obj_bossdoor) && REMIX
			{
				var ini = concat(global.cyop_path, "/levels/", inst.levelName, "/level.ini");
				if file_exists(ini)
				{
					ini_open(ini);
					var name = ini_read_string("data", "name", "");
					if name != "Level Name"
						inst.msg = name;
					ini_close();
				}
			}
			
			if safe_get(inst, "flipX")
			{
				var horDifference = sprite_get_width(inst.sprite_index) - (sprite_get_xoffset(inst.sprite_index) * 2);
		        inst.x += horDifference * inst.image_xscale;
		        inst.image_xscale *= -1;
			}
			if safe_get(inst, "flipY")
			{
				var verDifference = sprite_get_height(inst.sprite_index) - (sprite_get_yoffset(inst.sprite_index) * 2);
		        inst.y += verDifference * inst.image_yscale;
		        inst.image_yscale *= -1;
			}
		
			// saveroom
			if struct_exists(inst_data, "ID")
				inst.ID = inst_data.ID;
			else
				struct_set(inst_data, "ID", inst.id);
		}
		else
			trace("Instance of object ", objects[inst_data.object], " deleted itself upon create");
	}

	// backgrounds
	var backgrounds = variable_struct_get_names(_room.backgrounds);
	for(var i = 0, n = array_length(backgrounds); i < n; ++i)
	{
		var bg_data = _room.backgrounds[$ backgrounds[i]];
	
		var layer_num = real(backgrounds[i]);
		if layer_num < 0
			var lay = layer_create(-(500 + (10 * layer_num)));
		else
			var lay = layer_create(500 + (10 * layer_num));
		
		var bg = layer_background_create(lay, cyop_resolvevalue(bg_data.panic_sprite != -1 && global.panic ? bg_data.panic_sprite : bg_data.sprite, "spr"));
		layer_background_speed(bg, bg_data.image_speed);
		layer_background_htiled(bg, bg_data.tile_x);
		layer_background_vtiled(bg, bg_data.tile_y);
		layer_hspeed(lay, bg_data.hspeed);
		layer_vspeed(lay, bg_data.vspeed);
		layer_x(lay, bg_data.x);
		layer_y(lay, bg_data.y);
		
		with obj_persistent
		{
			array_push(room_bgs, {
				layer_id: lay,
				layer_name: concat("Backgrounds_", i),
				x: bg_data.x,
				y: bg_data.y,
				bg_id: bg,
				bg_sprite: layer_background_get_sprite(bg),
				par_x: 1 - bg_data.scroll_x,
				par_y: 1 - bg_data.scroll_y
			});
		}
	}
	with obj_persistent
	{
		array_sort(room_bgs, function(a, b) {
			return layer_get_depth(b.layer_id) - layer_get_depth(a.layer_id);
		});
	}

	// tiles
	//placed_tile = false;
	
	var tile_layers = variable_struct_get_names(_room.tile_data);
	var f = method({room_x: _room.properties.roomX, room_y: _room.properties.roomY, _room: _room}, function(this, i)
	{
		var tilelayer_data = _room.tile_data[$ this];
		
		var tiles = variable_struct_get_names(tilelayer_data);
		if !array_length(tiles)
			exit;
		
		var layer_num = real(this);
		if layer_num >= 0
			var depp = 15 * layer_num; // TODO this is 5, but it fucks up somehow.
		else
			var depp = -100 + layer_num;
		
		var layer_name = $"Tiles_{layer_num}";
		if !layer_exists(layer_name)
			var lay = layer_create(depp, layer_name);
		else
			lay = layer_get_id(layer_name);
		
		var secret = layer_num <= -5;
		var tilelayer = new cyop_tilelayer(-room_x, -room_y, tilelayer_data, depp, secret);
		
		//obj_cyop_loader.placed_tile = true;
		
		// saveroom
		var inst = instance_create_layer(0, 0, lay, obj_cyop_tilelayer, {tilelayer: tilelayer, secrettile: secret});
		if secret
		{
			if struct_exists(tilelayer_data, "ID")
				inst.ID = tilelayer_data.ID;
			else
				struct_set(tilelayer_data, "ID", inst.id);
			
			if in_saveroom(inst.id)
				inst.revealed = true;
		}
	});
	array_foreach(tile_layers, f, 0, infinity);
	
	//global.showcollisions = !placed_tile or instance_exists(obj_treasure);
	
	// song
	var song = _room.properties.song;
	var fade = _room.properties.songTransitionTime;
	var state = 0, fmod = string_starts_with(song, "event:");

	if fmod && string_pos(".", song) != 0
	{
		/*
			event:/music/w1/ruin.1
			the end part (.1) is the state
		*/
		var split = string_split(song, ".", true, 1);
		song = split[0];
		state = real(split[1]);
	}
	var event = fmod ? song : cyop_resolvevalue(song, "sound");

	if !is_string(event) or fmod
	{
		with obj_music
		{
			var found = -1;
			for(var i = 0; i < array_length(custom_music); i++)
			{
				if custom_music[i].event == event
				{
					found = i;
					break;
				}
			}
		
			if current_custom != noone && found != current_custom
			{
				if custom_music[current_custom].fmod
				{
					fmod_event_instance_set_paused(custom_music[current_custom].instance, true);
					custom_music[current_custom].paused = true;
				}
				else
					audio_sound_gain(custom_music[current_custom].instance, 0, fade);
			}
		
			if found > -1
			{
				current_custom = found;
				if custom_music[found].fmod
				{
					custom_music[found].paused = false;
					fmod_event_instance_set_paused(custom_music[found].instance, false);
				}
				else
					audio_sound_gain(custom_music[found].instance, global.option_music_volume * 0.5, fade);
			}
			else
			{
				current_custom = array_length(custom_music);
				array_push(custom_music, {event: event, instance: noone, fmod: fmod, state: state, paused: false});
			}
		}
	}
	
	// combotimepause (AFOM?)
	global.combotimepause = prop[$ "pausecombo"] ?? 0;
	
	// do it asshole
	with all
	 	event_perform(ev_other, ev_room_start);
	scr_panicbg_init();
}
catch (e)
{
	audio_pause_all();
	audio_play_sound(sfx_pephurt, 0, false);
	show_debug_message(string(e));
	show_message($"Unable to load room \"{obj_cyop_loader.room_name}\"!\n\n---\n\n{e.longMessage}\n---\n\nstacktrace: {e.stacktrace}");
	audio_resume_all();
}

if instance_exists(obj_trash)
	instance_create_unique(0, 0, obj_surfback);
