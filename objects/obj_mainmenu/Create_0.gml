live_auto_call;

currentselect = 0;
optionbuffer = 0;
visualselect = 0;
state = states.titlescreen;
image_speed = 0.35;
depth = 0;
mainmenu_sprite = -1;
controls_sprite = -1;
angrybuffer = 0;
savedsprite = noone;
savedindex = 0;
deleteselect = 1;
exitselect = 1;
percvisual = 0;
taunt_key = scr_compile_icon_text("[x]");
grab_key = scr_compile_icon_text("[q]");
start_key = scr_compile_icon_text("[p]");
jumpscarecount = 0;
quitbuffer = 0;
shownoise = false;
showswap = false;
showbuffer_max = 300;
john = true;
snotty = true;
judgement = "confused";
deletebuffer = 0;
obj_player1.player_paletteselect[0] = 1;
obj_player1.player_paletteselect[1] = 1;
obj_player1.paletteselect = 1;
percentage = 0;
perstatus_icon = 0;
extrauialpha = 0;
punch_x = 0;
punch_y = 0;
key_jump = false;
index = 0;
bombsnd = fmod_event_create_instance("event:/sfx/ui/bombfuse");
scr_init_input();

pep_percvisual = 0;
pep_alpha = 1;
noise_percvisual = 0;
noise_alpha = 0;
pep_debris = false;
game_icon_y = 0;
game_icon_buffer = 0;
game_icon_index = 0;
punch_count = 0;

charselect = 0;
game = -4;
extramenusel = 0;
extramenualpha = 1;

draw_icon = function()
{
	var status_x = 183;
	var status_y = 312;
	
	// sandbox
	var icon = -1;
	switch charselect
	{
		case -1: icon = spr_mainmenu_pepicon; break;
		case 0: icon = spr_mainmenu_cheeseicon; break;
		case 1: icon = spr_mainmenu_storyicon; break;
		case 2: icon = spr_mainmenu_optsicon; break;
	}
	if icon != -1
		draw_sprite_ext(icon, game_icon_index, status_x - 100, status_y + 195 + game_icon_y, 1, 1, 0, c_white, extrauialpha);
	if charselect == 0
		draw_sprite_ext(spr_cheese, 0, -20 + (status_x - 100), -10 + (status_y + 195 + game_icon_y), .5, .5, 0, c_white, extrauialpha);
}

/* reset command!

obj_mainmenu.state = global.states.titlescreen;
obj_mainmenu.extrauialpha = 0;
obj_mainmenu.sprite_index = spr_titlepep_forward;
obj_mainmenu.extramenualpha = 1;
obj_shell.isOpen = false;
fmod_event_instance_stop(obj_music.music.event, true);
fmod_event_instance_set_parameter(obj_music.music.event, "state", 0, true);
fmod_event_instance_play(obj_music.music.event);
*/
