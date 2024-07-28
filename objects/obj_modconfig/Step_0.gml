live_auto_call;
ensure_order;

// subsection
if !visible
{
	buffer = 2;
	exit;
}
if buffer-- > 0
{
	buffer--;
	exit;
}

// get input
scr_menu_getinput();

// move
var move = key_down2 - key_up2;
var move_hor = key_left2 + key_right2;

if move_buffer == 0
{
	move = key_down - key_up;
	move_hor = key_left + key_right;
	move_buffer = 5;
}
else if (move != 0 or move_hor != 0) && move_buffer == -1
	move_buffer = 20;

if key_down - key_up != 0 or key_left + key_right != 0
{
	if move_buffer > 0
		move_buffer--;
}
else
	move_buffer = -1;

// state machine
switch state
{
	case 0: // sections
		if move_hor != 0
		{
			if (sel > 0 && move_hor == -1) or (sel < array_length(sections_array) - 1 && move_hor == 1)
			{
				menu_xo = move_hor * 25;
				alpha = 0;
				sel += move_hor;
				sound_play(sfx_step);
				
				scroll = 0;
			}
			else
				menu_xo = move_hor * 10;
		}
		state_trans = Approach(state_trans, 0, 0.25);
		scroll = lerp(scroll, 0, 0.25);
		
		if key_jump
		{
			var section = sections_array[sel];
			with section
			{
				if sel == -1
					sel = 0;
				while options_array[sel].type == modconfig.section
					sel++;
				select(sel);
			}
			
			state = 1;
			state_trans = 0;
			
			yo = -20;
		}
		
		// SAVE
		if key_back
		{
			ini_open_from_string(obj_savesystem.ini_str_options);
			for(var j = 0; j < array_length(sections_array); j++)
			{
				with sections_array[j]
				{
					for(var i = 0; i < array_length(options_array); i++)
					{
						var opt = options_array[i];
						if opt.type == modconfig.option
						{
							var value = opt.opts[opt.value][1];
							variable_global_set(opt.vari, value);
			
							if is_real(value)
								ini_write_real("Modded", opt.vari, value);
							else
								ini_write_string("Modded", opt.vari, value);
						}
						if opt.type == modconfig.slider
						{
							var value = (opt.range[0] + (opt.range[1] - opt.range[0]) * opt.value);
							variable_global_set(opt.vari, value);
							ini_write_real("Modded", opt.vari, value);
						}
					}
				}
			}
			ini_write_string("Modded", "inputdisplay", global.inputdisplay);
			obj_savesystem.ini_str_options = ini_close();
			
			gamesave_async_save_options();
			with obj_option
				backbuffer = 2;
			with create_transformation_tip(lstr("mod_saved"))
			{
				depth = -700;
				alarm[1] = 100;
			}
			sound_play(sfx_back);
			instance_destroy();
		}
		break;
	
	case 1: // configs
		var section = sections_array[sel];
		if key_back
		{
			sound_play(sfx_back);
			section.select(-1);
			
			state = 0;
			yo = 20;
		}
		state_trans = Approach(state_trans, 1, 0.25);
		
		if move != 0
		{
			control_mouse = false;
			yo = 10 * -move;
			
			with section
			{
				sel = max(sel, 0);
	
				sel += move;
				if sel >= array_length(options_array)
					sel = 0;
				if sel < 0
					sel = array_length(options_array) - 1;
				
				while options_array[sel].type == modconfig.section
				{
					sel += move;
					if sel < 0
						sel = array_length(options_array) - 1;
				}
				select(sel);
			}
		}
		
		if section.sel != -1
		{
			// change values
			var opt = section.options_array[section.sel], locked = false;
			if opt.type != modconfig.section && is_callable(opt.condition)
			{
				locked = opt.condition();
				if is_array(locked)
					locked = !(locked[0]);
			}

			if !locked
			{
				if opt.type == modconfig.slider
				{
					var move2 = key_left + key_right;
					if move2 != 0
					{
						image_index = 8;
						xo = 10;
		
						opt.value = clamp(opt.value + move2 * (((key_attack * 2) + 1) / 100), 0, 1);
					}
				}
				else
				{
					var move2 = key_left2 + key_right2;
					//if control_mouse && mouse_check_button_pressed(mb_right)
					//	move2 = -1;
			
					if move2 != 0
					{
						image_index = 8;
						xo = 10;
		
						if opt.type != modconfig.button
						{
							simuplayer.changed = true;
							
							var valueold = opt.value;
							opt.value = clamp(opt.value + move2, 0, array_length(opt.opts) - 1);
	
							if valueold != opt.value
								sound_play(sfx_step);
						}
						refresh_sequence();
					}
					if key_jump// or (control_mouse && mouse_check_button_pressed(mb_left))
					{
						image_index = 8;
						xo = 10;
	
						sound_play(sfx_select);
	
						if opt.type != modconfig.button
							opt.value = wrap(opt.value + 1, 0, array_length(opt.opts) - 1);
						else
						{
							if is_callable(opt.func)
								opt.func();
						}
						refresh_sequence();
					}
				}
			}
			else if key_jump
			{
				image_index = 8;
				xo = 10;
				sound_play("event:/sfx/misc/golfjingle");
			}
		}

		// figure out scroll
		if section.sel >= 0
		{
			var scrolltarget = max(section.options_pos[section.sel] - SCREEN_HEIGHT / 2, 0);
			section.sel = max(section.sel, 0);
		
			scroll = lerp(scroll, scrolltarget, 0.2);
		}
		break;
}

var section_pos = 100 + sel * 280 - section_scroll[0];
if section_pos > SCREEN_WIDTH - 100
	section_scroll[0] += 100;
if section_pos < 100
	section_scroll[0] -= 100;

section_scroll[1] = lerp(section_scroll[1], section_scroll[0], 0.25);

menu_xo = lerp(menu_xo, 0, 0.25);
if abs(menu_xo) < 1
	menu_xo = 0;

xo = lerp(xo, 0, 0.25);
yo = lerp(yo, 0, 0.25);
alpha = lerp(alpha, 1, 0.25);
