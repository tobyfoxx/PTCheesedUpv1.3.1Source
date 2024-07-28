live_auto_call;

if instance_exists(obj_loadingscreen)
	exit;

camera_set_view_pos(view_camera[0], -floor(SCREEN_WIDTH / 2 - 960 / 2), -floor(SCREEN_HEIGHT / 2 - 540 / 2))

// restart the disclaimer if you turn on your internet
//if !net && net != os_is_network_connected(true)
//	room_restart();

if DEBUG && keyboard_check_pressed(ord("R"))
	room_restart();

// animation
if (menu == 1 && state == 2) or menu == 2
{
	if t == 0
		sound_play("event:/modded/sfx/diagopen");
	
	t = Approach(t, 1, 0.075);
	size = animcurve_channel_evaluate(outback, t);
}

// firstboot sequence
if menu == 0
{
	fade_alpha -= 0.1;
	if state == 1
		scr_menu_getinput();
	else if state == 2
	{
		// check if firstboot
		ini_open("saveData.ini");
		var firstboot = ini_read_real("Modded", "first_boot", 0) == 0;
		var discl = (ini_read_real("Modded", "disclaimer", 0) == 0/* or PLAYTEST*/) && !instance_exists(obj_surfback);
		ini_close();
		
		instance_destroy(obj_surfback);
		if discl
		{
			disclaimer = {};
			
			draw_set_font(lang_get_font("creditsfont"));
			disclaimer.header = scr_compile_icon_text("{s}Disclaimer/");
			disclaimer.header_size = scr_text_arr_size(disclaimer.header);
			disclaimer.wait = room_speed * 3;
			
			t = 1;
			state = 1;
			
			scr_menu_getinput();
		}
		else if firstboot
		{
			// load files
			var found = false;
			var path = environment_get_variable("APPDATA") + "/PizzaTower_GM2";
			
			if file_exists(path + "/saveData.ini")
			{
				ini_open(path + "/saveData.ini");
				options = {
					ptt: ini_section_exists("Modded"),
					beaten: ini_read_real("Game", "beaten", false)
				}
				ini_close();
				
				found = true;
			}
			else
				sel = 1;
			
			for(var i = 0; i < 3; i++)
			{
				var file = concat(path, "/saves/saveData", i + 1, ".ini");
				if file_exists(file)
				{
					ini_open(file);
					saves[i] = {
						percent: ini_read_real("Game", "percent", 0),
						minutes: ini_read_real("Game", "minutes", 0),
						seconds: ini_read_real("Game", "seconds", 0),
						john: ini_read_real("Game", "john", 0),
						snotty: ini_read_real("Game", "finalsnotty", 0),
						finalrank: ini_read_string("Game", "finalrank", ""),
					}
					ini_close();
					
					found = true;
				}
				else if sel - 1 == i
					sel++;
			}
			
			// open menu
			if found
			{
				with instance_create(0, 0, obj_loadingscreen)
					group_arr = ["menugroup"];
				menu = 1;
			}
			else
				state = 3;
		}
		else
		{
			fade_alpha = 2;
			state = 3;
		}
	}
	
	// go
	else if state == 3
	{
		if YYC
		{
			if !are_you_sure && !DEBUG // impossible
				instance_create(0, 0, obj_softlockcrash);
			
			global.collect2 = array_create(5, true);
		}
		state = -1;
		
		room_goto(Realtitlescreen);
	}
	else if state == -1
	{
		
	}
	else if YYC
	{
		if are_you_sure && !DEBUG // impossible
			instance_create(0, 0, obj_softlockcrash);
	}
}
else if menu == 1
{
	if state == 3
	{
		t = Approach(t, 0, 0.1);
		size = animcurve_channel_evaluate(incubic, t);
		
		if t == 0
			fade_alpha = Approach(fade_alpha, 1, 0.1);
		if fade_alpha == 1
		{
			menu = 0;
			get_options();
			load_moddedconfig();
		}
	}
	else
	{
		fade_alpha = Approach(fade_alpha, 0, 0.1);
		scr_getinput();
		
		var move = key_down2 - key_up2;
		if move != 0 && sel + move > -1 && sel + move < 5
		&& (options != noone or sel + move > 0)
		{
			sound_play(sfx_step);
			sel += move;
			
			while sel > 0 && sel < 4 && saves[sel - 1] == noone
				sel += move;
			pizzashift[1] = -move * 10;
		}
		
		if key_jump or keyboard_check_pressed(vk_enter)
		{
			if sel == 4
			{
				sound_play("event:/modded/sfx/diagclose");
				
				var path = environment_get_variable("APPDATA") + "/PizzaTower_GM2";
				if selected[0]
					file_copy(path + "/saveData.ini", "saveData.ini");
				for(var i = 1; i < 4; i++)
				{
					var file = concat(path, "/saves/saveData", i, ".ini");
					if selected[i]
						file_copy(file, concat("saves/saveData", i, ".ini"));
				}
				
				menu = 0;
				state = 2;
				
				make_firstboot_file();
			}
			else
			{
				selected[sel] = !selected[sel];
				sound_play(sfx_select);
			
				pizzashift[0] = 15;
				image_index = 8;
			}
		}
	
		pizzashift[0] = lerp(pizzashift[0], 0, 0.25);
		pizzashift[1] = lerp(pizzashift[1], 0, 0.25);
	}
}
else if PLAYTEST && menu == 2 // playtest
	fade_alpha = Approach(fade_alpha, 0, 0.1);
else if menu == 3 // crash handler
{
	if state == 2
		fade_alpha = Approach(fade_alpha, 3, 0.2);
	else
		fade_alpha = Approach(fade_alpha, 0, 0.1);
	
	scr_menu_getinput();
	if (key_jump or keyboard_check_pressed(vk_enter))
	&& state != 2
	{
		sound_play("event:/modded/sfx/diagclose");
		state = 2;
	}
	
	if state == 2 && fade_alpha >= 3
	{
		file_delete("crash_log.txt");
		file_delete("crash_img.png");
		
		fade_alpha = 1;
		menu = 0;
		state = 2;
		are_you_sure = true;
		size = 0;
		t = 0;
	}
}

if YYC
{
	// drm
	if !is_array(global.collect2)
		instance_create(0, 0, obj_softlockcrash);
	for(var i = 1; i < 5; i++)
	{
		if global.collect2[i - 1] != global.collect2[i]
		or (global.collect2[i] != false && state != -1)
			instance_create(0, 0, obj_softlockcrash);
	}
}
