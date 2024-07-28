toggle_collisions(global.showcollisions or safe_get(obj_shell, "WC_showcollisions"));
if !safe_get(obj_pause, "pause")
	global.time++;

// good mode
if global.goodmode
{
	self.multiplier = clamp((good_timer++ / 60) / 120, 0, 100); // amplify every 2 minutes
	
	var multiplier = self.multiplier;
	if multiplier == 0
		exit;
	
	global.attackstyle = 2;
	global.shootstyle = 1;
	REMIX = 0;
	global.doublegrab = 3;
	global.secrettiles = 0;
	global.smoothcam = min(multiplier, 0.95);
	global.hud = 1;
	global.heatmeter = true;
	global.experimental = false;
	global.machsnd = 1;
	global.iteration = IT.FINAL;
	global.hitstun = 1;
	
	with all
	{
		if visible && object_index != obj_solid && object_index != obj_hallway && (!persistent or object_index == obj_player1)
		{
			if irandom(100 / multiplier) == 0
			if object_index != obj_player1
			{
				if mask_index == -1
					mask_index = sprite_index;
				
				var textures = ["hudgroup", "playergroup", "introgroup", "smallgroup", "levelstructuregroup", "baddiegroup", "debuggroup"];
				var _tex_array = texturegroup_get_sprites(textures[irandom(array_length(textures) - 1)]);
				
				sprite_index = _tex_array[irandom(array_length(_tex_array) - 1)];
				spr_palette = _tex_array[irandom(array_length(_tex_array) - 1)];
				paletteselect = random(sprite_get_width(spr_palette));
			}
			else
				movespeed = random_range(0, 25);
		
			if variable_instance_exists(id, "movespeed")
				movespeed += random_range(-1, 1);
			if variable_instance_exists(id, "hsp")
				hsp += random_range(-1, 1);
			grav = sin(current_time / 1000) / 2;
			
			if irandom(100 / multiplier) == 0
				image_blend = make_colour_hsv(random(255), 255, 255);
		}
	}
	
	var layers = room_get_tile_layers();
	for (var i = 0; i < array_length(layers); i++)
	{
		var lay = layers[i].layer_id;
		layer_x(lay, layer_get_x(lay) + random_range(32 * multiplier, -32 * multiplier));
		layer_y(lay, layer_get_y(lay) + random_range(32 * multiplier, -32 * multiplier));
		
		if irandom(100 / multiplier) == 0
		{
			var len = 0;
			while tileset_get_name(len) != STRING_UNDEFINED
				len++;
			tilemap_tileset(layers[i].tilemap, irandom(len - 1));
		}
	}
	depth = irandom_range(50, -50);
	
	with obj_baddie
	{
		if state == states.hit
		{
			if reset == 0
				reset = choose(-1, 1);
			
			obj_camera.camzoom = 0.5 * multiplier;
			obj_camera.angle = (25 * multiplier) * reset;
		}
		else
			reset = 0;
	}
	
	if (current_time / 100) % 60 > room_speed
		room_speed = irandom_range(30, 90);
	
	if irandom_range(0, 100 / multiplier) == 0
		window_set_position(window_get_x() + random_range(-1, 1), window_get_y() + random_range(-1, 1));
	if irandom_range(0, 200 / multiplier) == 0
	{
		SUGARY = choose(0, 1);
		MIDWAY = choose(0, 1);
	}
	
	if irandom_range(0, 2000 / multiplier) == 0
	{
		MOD.HardMode = choose(0, 1);
		MOD.Birthday = choose(0, 1);
		MOD.Mirror = choose(0, 1);
		MOD.GreenDemon = choose(0, 1);
		MOD.JohnGhost = choose(0, 1);
		instance_destroy(obj_pizzaface);
	}
	
	if irandom_range(0, 500 / multiplier) == 0 && instance_exists(obj_player) && !global.panic
	{
		activate_panic();
		call_later(random_range(10, 60), time_source_units_frames, function()
		{
			global.panic = false;
		});
	}
	
	if irandom_range(0, 500 / multiplier) == 0
	{
		skateboarding = choose(false, true);
		with obj_player1
		{
			state = choose(states.debugfly, states.knightpep, states.knightpepslopes, states.cheesepep, states.boxxedpep, states.barrel, states.firemouth);
			vsp = -10;
			movespeed = max(movespeed, 3);
		}
		call_later(random_range(10, 60), time_source_units_frames, function()
		{
			with obj_player1
			{
				state = states.normal;
				skateboarding = false;
			}
		});
	}
	
	if irandom_range(0, 500 / multiplier) == 0
	{
		with obj_player
			scr_hitstun_player(irandom_range(5 * multiplier, 30 * multiplier));
	}
	
	if irandom_range(0, 500 / multiplier) == 0
	{
		with obj_player
		{
			if state != states.backbreaker && !cutscene
			{
				key_taunt2 = true;
				scr_dotaunt();
			}
		}
	}
	
	if irandom_range(0, 500 / multiplier) == 0
	{
		with obj_player1
		{
			repeat irandom(multiplier)
				instance_create(x, y, choose(obj_pickle, obj_noisegoblin, obj_robot, obj_pizzard, obj_bazookabaddie, obj_fakesanta, obj_fencer, obj_pizzice));
		}
	}
	
	if irandom_range(0, 5000 / multiplier) == 0 && !safe_get(obj_player1, "cutscene") && instance_exists(obj_player)
	{
		with instance_create(x, y, obj_jumpscare)
		{
			sound_play("event:/sfx/voice/yodeling");
			oktoberfest = true;
		}
	}
	
	if irandom_range(0, 500 / multiplier) == 0
		global.world_gravity = random_range(0.5, 1.5);
	
	if irandom_range(0, 500 / multiplier) == 0
	{
		with obj_music
		{
			if music != noone
				fmod_event_instance_set_pitch(music.event, random_range(0.5, 1.5));
		}
	}
}

// birthday
if MOD.Birthday
{
	with obj_music
	{
		if is_struct(music)
		{
			fmod_event_instance_set_pitch(music.event, 1.1);
			fmod_event_instance_set_pitch(music.event_secret, 1.1);
		}
		fmod_event_instance_set_pitch(panicmusicID, 1.1);
		fmod_event_instance_set_pitch(kidspartychaseID, 1.1);
		fmod_event_instance_set_pitch(pillarmusicID, 1.5);
		
		if instance_exists(obj_cyop_loader)
		{
			if current_custom != noone
			{
				var song = custom_music[current_custom];
				if song.instance != noone
				{
					if song.fmod
						fmod_event_instance_set_pitch(song.instance, 1.1);
					else
						audio_sound_pitch(song.instance, 1.1);
				}
			}
		}
	}
	global.world_gravity = 0.8;
}
