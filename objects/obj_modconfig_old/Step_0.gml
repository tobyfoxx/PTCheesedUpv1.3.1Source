live_auto_call;
ensure_order;

// subsection
if !visible
{
	buffer = 2;
	exit;
}
if buffer > 0
{
	buffer--;
	exit;
}

// get input
scr_menu_getinput();

// move
var move = key_down2 - key_up2;
if move_buffer == 0
{
	move = key_down - key_up;
	move_buffer = 5;
}
else if move != 0 && move_buffer == -1
	move_buffer = 20;

if key_down - key_up != 0
{
	if move_buffer > 0
		move_buffer--;
}
else
	move_buffer = -1;

if move != 0
{
	control_mouse = false;
	sel = max(sel, 0);
	
	sel += move;
	if sel >= array_length(options_array)
		sel = 0;
	if sel < 0
		sel = array_length(options_array) - 1;
	
	yo = 10 * -move;
	while options_array[sel].type == modconfig.section
	{
		sel += move;
		if sel < 0
			sel = array_length(options_array) - 1;
	}
	select(sel);
}

xo = lerp(xo, 0, 0.25);
yo = lerp(yo, 0, 0.25);
//alpha = lerp(alpha, 1, 0.25);

if sel != -1
{
	// change values
	var opt = options_array[sel], locked = false;
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
			if control_mouse && mouse_check_button_pressed(mb_right)
				move2 = -1;
			
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
			if key_jump or (control_mouse && mouse_check_button_pressed(mb_left))
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
if control_mouse
{
	if mouse_wheel_down()
		scrolltarget += 40;
	if mouse_wheel_up()
		scrolltarget -= 40;
	scrolltarget = clamp(scrolltarget, 0, array_last(options_pos) - SCREEN_HEIGHT / 2);
}
else
{
	scrolltarget = max(options_pos[sel] - SCREEN_HEIGHT / 2, 0);
	sel = max(sel, 0);
	
	/*
	if mouse_check_button(mb_left)
	{
		control_mouse = true;
		select(-1);
	}
	*/
}
scroll = lerp(scroll, scrolltarget, 0.2);
