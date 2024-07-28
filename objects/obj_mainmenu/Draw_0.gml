live_auto_call;

var cx = camera_get_view_x(view_camera[0]);
var cy = camera_get_view_y(view_camera[0]);
draw_sprite_ext(spr_blackbars, 0, cx, cy, SCREEN_WIDTH / 64, SCREEN_HEIGHT / 64, 0, c_white, 1);

var i = 0;
if is_holiday(holiday.halloween)
	i = 1;
draw_sprite(spr_mainmenu_bg, i, SCREEN_X, 0);

with obj_menutv2
	event_perform(ev_draw, 0);
with obj_explosioneffect
	draw_self();

shader_set(global.Pal_Shader);
var _x = SCREEN_WIDTH * 0.50625;
var _y = y;

var spr = sprite_index, pal = 1, tex = noone;
if is_struct(game)
{
	var char = game.character;
	if char == "P" or char == "G"
	{
		pal = game.palette;
		tex = game.palettetexture;
		
		//spr = SPRITES[? sprite_get_name(spr) + char] ?? sprite_index;
	}
}

if !pep_debris
{
	if tex != noone
		pattern_set(global.Base_Pattern_Color, spr, image_index, image_xscale, image_yscale, tex);
	pal_swap_set(spr_peppalette, pal, false);
	draw_sprite_ext(spr, image_index, _x, _y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	if tex != noone
	    pattern_reset();
	pal_swap_reset();
}

draw_set_alpha(extrauialpha * extramenualpha);

var qx = 0;
var qy = 0;
draw_sprite(spr_quitgame, 0, qx, qy);
scr_draw_text_arr(qx + 50, qy + 100, grab_key);

draw_set_font(lang_get_font("bigfont"));
draw_set_align(fa_center, fa_middle);
draw_set_color(c_white);
var options_x = SCREEN_WIDTH * 0.853125;
var options_y = 84;
draw_sprite(spr_controlseggplant, 0, options_x, options_y);
scr_draw_text_arr(options_x - 88, options_y - 37, start_key, c_white);

var status_x = 183;
var status_y = 312;
var percentstate_x = 199;
var percentstate_y = 443;
var deletefile_x = 779;
var deletefile_y = 449;

// delete file
draw_sprite(spr_deletefile, 0, deletefile_x, deletefile_y);
var dal = 1;
if !is_struct(game) or !game.started
	dal = 0.5;
scr_draw_text_arr(deletefile_x - 67, deletefile_y, taunt_key, c_white, dal);

// story mode stats
if is_struct(game)
{
	draw_sprite(spr_towerstatusmenu, 0, status_x, status_y);
	
    draw_set_font(global.combofont);
	draw_set_align(fa_center, fa_middle);
    draw_text(status_x + 8, status_y + 10, floor(game.percvisual));
    draw_sprite(spr_percentstatemenu, game.perstatus_icon, percentstate_x, percentstate_y);
	
	if game.john
	    draw_sprite(spr_menu_approvedjohn, 0, percentstate_x - 80, percentstate_y);
	if game.snotty
	    draw_sprite(spr_menu_approvedsnotty, 0, percentstate_x + 70, percentstate_y);
			
	if game.judgement != "none"
	{
	    var _i = 0;
	    switch game.judgement
	    {
	        case "confused": _i = 0; break;
	        case "quick": _i = 1; break;
	        case "officer": _i = 2; break;
	        case "yousuck": _i = 3; break;
	        case "nojudgement": _i = 4; break;
	        case "notbad": _i = 5; break;
	        case "wow": _i = 6; break;
	        case "holyshit": _i = 7; break;
	    }

	    var spr = spr_menu_finaljudgement;
	    if game.character == "N"
	        spr = spr_menu_finaljudgementN;
	    draw_sprite(spr, _i, percentstate_x, percentstate_y + 50);
	}
}

// extra
draw_set_alpha((1 - extramenualpha) * .6);
draw_rectangle_color(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0, false);

draw_set_alpha((1 - extramenualpha));
draw_set_font(lang_get_font("creditsfont"));

var extramenu_opts = ["Erase All Data", "Filler Option", "Send Belly Pics"];
for(var i = 0, n = array_length(extramenu_opts); i < n; i++)
{
	draw_set_colour(extramenusel == i ? c_white : c_gray);
	
	var xx = SCREEN_WIDTH / 2 + 20, yy = SCREEN_HEIGHT / 2 - ((n / 2) * 40) + (i * 40);
	var str = extramenu_opts[i];
	draw_text_color(xx, yy + 2, str, 0, 0, 0, 0, 1 - extramenualpha);
	draw_text(xx, yy, str);
	
	if extramenusel == i
		draw_sprite(spr_cursor, current_time / 60, xx - string_width(str) / 2 - 45, yy + 3);
}

draw_set_alpha(1);
draw_icon();
