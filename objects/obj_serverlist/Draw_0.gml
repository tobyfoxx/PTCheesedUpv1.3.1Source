live_auto_call;

/*
if keyboard_check_pressed(ord("R"))
{
	instance_destroy();
	instance_create(0, 0, obj_serverlist);
	exit;
}
*/

bgscroll -= 0.25;

// animation curve
var curve = 1;
if state == 0
{
	t = Approach(t, 1, 0.025);
	curve = animcurve_channel_evaluate(outback, t);
	
	if t >= 1
		state = 1;
}
if obj_mainmenu.charselect != -1 && state != 2
{
	state = 2;
	sound_play("event:/modded/sfx/diagclose");
}
if state == 2
{
	t = Approach(t, 0, 0.1);
	curve = animcurve_channel_evaluate(incubic, t);
	
	if t <= 0
	{
		instance_destroy();
		exit;
	}
}

// draw bg
if curve < 1
{
	draw_circle(SCREEN_WIDTH / 2 - 1, SCREEN_HEIGHT / 2 - 1, (SCREEN_WIDTH / (960 / 560)) * curve + 5, false);
	draw_set_spotlight(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, (SCREEN_WIDTH / (960 / 560)) * curve);
}

draw_sprite(spr_characterselectbackground, 0, 0, 0);

// boxes
var pad = 32;
draw_box(pad, pad, 960 - pad * 2, 540 - pad * 2);

var title = spr_titleeggplant;
draw_sprite(title, 0, SCREEN_WIDTH / 2 - sprite_get_width(title) / 2, 50);

draw_set_font(global.bigfont);
draw_set_align(fa_center);
draw_text(SCREEN_WIDTH / 2, 320, "ONLINE\nUNITED\nTOGETHER\nNETWORK");

var text = pto_textbox(pad * 10, 540 - pad * 2.5, 960 - pad * (10 * 2), pad, 12, "Username").str;

if curve < 1
	draw_set_spotlight(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, (SCREEN_WIDTH / (960 / 560)) * curve);

// CONNECT
if state != 3
{
	if (pto_button(700, 540 - pad * 4, 200, , , , , "Connect") == 2 or keyboard_check_pressed(vk_enter)) && state == 1 && !instance_exists(obj_fadeout)
	{
		// uname cheeck
		for(var i = 1; i <= string_length(text); i++)
		{
			var char = string_char_at(text, i);
		
			if !((ord(char) >= ord("A") && ord(char) <= ord("Z"))
			or (ord(char) >= ord("a") && ord(char) <= ord("z"))
			or ord(char) == ord("_")
			or (ord(char) >= ord("0") && ord(char) <= ord("9")))
			{
				message_show("ONLY A-Z, 0-9, UNDERSCORES!");
				exit;
			}
		}
	
		// create online
		with instance_create(0, 0, obj_onlineclient)
			username = text;
	
		state = 3;
	}
}

// connecting...
else if !instance_exists(obj_fadeout)
{
	with obj_mainmenu
		state = -1;
	draw_sprite_ext(spr_loading, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 1, 1, current_time / 2, c_white, 1);
	
	if !instance_exists(obj_onlineclient)
	{
		with obj_mainmenu
			state = states.normal;
		
		message_show("COULD NOT CONNECT!");
		state = 1;
	}
	else if obj_onlineclient.state == online_state.connected
	{
		with obj_player1
			character = "";
		
		sound_play(sfx_collecttoppin);
		scr_start_game(1, true);
	}
}

// main menu switch icon
shader_reset();
with obj_mainmenu
	draw_icon();
