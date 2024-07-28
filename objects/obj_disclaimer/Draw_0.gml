live_auto_call;

if instance_exists(obj_loadingscreen)
	exit;

// surface bullshit
if !surface_exists(surf)
	surf = surface_create(960, 540);
surface_set_target(surf);
draw_clear_alpha(c_black, 0);

// roundrect
draw_set_colour(c_black);

var xx = 50 * size;
var yy = 32 * size;
var xsiz = (960 / 2) * (1 - size);
var ysiz = (540 / 2) * (1 - size);
var rectsize = 5;

draw_set_alpha(0.95);
draw_roundrect_ext(xx + xsiz, yy + ysiz, 960 - xx - xsiz, 540 - yy - ysiz, 12, 12, false);
gpu_set_blendmode(bm_subtract);
draw_set_alpha(0.1);
draw_roundrect_ext(xx + xsiz + rectsize, yy + ysiz + rectsize, 960 - xx - xsiz - rectsize, 540 - yy - ysiz - rectsize, 12, 12, false);
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);

// draw it
surface_reset_target();
draw_surface(surf, 0, 0);

// disclaimer
if menu == 0
	draw_rectangle_color(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0, false);
if state == 0 && menu == 0
{
	draw_set_align(fa_center, fa_middle);
	draw_set_font(lang_get_font("font_small"));
	draw_set_colour(c_white);
	draw_text(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, "Checking availability...");
}

if t >= 1 or menu == 3
switch menu
{
	case 0:
		if state == 1
		{
			// disclaimer
			draw_set_halign(fa_left);
			draw_set_colour(c_white);
			
			var disclaimer_alpha = clamp((room_speed * 3 - disclaimer.wait - 20) / 20, 0, 1);
			draw_set_alpha(disclaimer_alpha);
			
			draw_set_font(lang_get_font("creditsfont"));
			scr_draw_text_arr(SCREEN_WIDTH / 2 - disclaimer.header_size[0] / 2, 100, disclaimer.header, merge_colour(c_red, c_white, 0.25), disclaimer_alpha);
			
			draw_set_font(font1);
			draw_set_halign(fa_center);
			
			if PLAYTEST
				draw_text(SCREEN_WIDTH / 2, 180, "This is a playtester build for the mod.\nDo not share it anywhere.");
			else
				draw_text(SCREEN_WIDTH / 2, 180, "This mod is only shared through our Discord.\nIf you got this mod through any other means, please report it.");
			
			// blatant advertisement
			if text_button(SCREEN_WIDTH / 2, 220, "\n    PT:CU Discord    \n\n", #5865F2, c_white) == 2
			{
				sound_play(sfx_collect);
				url_open("https://discord.gg/thenoise");
			}
			
			// continue button
			if disclaimer.wait-- <= 0 or PLAYTEST
			{
				draw_set_font(lang_get_font("creditsfont"));
				if !PLAYTEST
					draw_set_alpha(clamp(-disclaimer.wait / 20, 0, 1));
				
				if text_button(960 / 2, 440, "Continue", c_dkgray, c_white) == 2
				or (key_jump or keyboard_check_pressed(vk_enter))
				{
					sound_play("event:/modded/sfx/diagclose");
					state = -2;
					disclaimer.wait = 30;
					
					ini_open("saveData.ini");
					ini_write_real("Modded", "disclaimer", 1);
					ini_close();
				}
			}
		}
		else if state == -2
		{
			if disclaimer.wait-- <= 0
			{
				instance_create_unique(0, 0, obj_surfback);
				room_restart();
			}
		}
		break;
	
	case 1:
		draw_set_align(fa_center);
		draw_set_color(c_white);
		
		var str = "Select which savefiles you want to port from the base game.\nIf you already had saves for this mod, this will replace them!";
		
		draw_set_font(lang_get_font("font_small"));
		draw_text_color(960 / 2 + 3, 70 + 3, str, 0, 0, 0, 0, 0.25);
		draw_text(960 / 2, 70, str);
		
		draw_option = function(ind, xx, yy, text, text2 = "", width = 600, height = 60)
		{
			draw_set_colour(merge_colour(c_black, c_green, selected[ind] * 0.35));
			draw_set_alpha(0.75);
			draw_roundrect(xx, yy, xx + width, yy + height, false);
			
			draw_set_font(font1);
			draw_set_colour(c_white);
			draw_set_alpha(1);
			draw_set_align(fa_left, fa_middle);
			draw_text(xx + 54, yy + height / 2, text);
			
			draw_set_align(fa_right, fa_middle);
			draw_text(xx + width - 32, yy + height / 2, text2);
			
			draw_roundrect(xx + 16, yy + 20, xx + 16 + 20, yy + 40, true);
			if selected[ind]
			{
				draw_set_font(lang_get_font("smallfont"));
				draw_text(xx + 35, yy + 31, "X");
			}
			
			if sel == ind
				draw_sprite(spr_cursor, image_index, xx - 50 + pizzashift[0], yy + height / 2 + pizzashift[1]);
		}
		
		var full = false;
		var xx = 960 / 2 - 300;
		var yy = 140;
		
		if options != noone && saves[0] != noone && saves[1] != noone && saves[2] != noone
			full = true;
		
		if options != noone
		{
			var str = "";
			//if options.beaten
			//	str += "Game was beaten\n";
			if options.ptt
				str += "(Has PTT mod config)\n";
			draw_option(0, xx, yy, "Configuration File", str);
			
			yy += full ? 70 : 90;
		}
		for(var i = 0; i < 3; i++)
		{
			if saves[i] != noone
			{
				var xdraw = xx;
				
				var str = "";
				str += concat(saves[i].percent, "%\n");
				str += concat(saves[i].minutes, ":", string_replace(string_format(floor(saves[i].seconds), 2, 0), " ", "0"), "\n");
				
				draw_option(i + 1, xx, yy, concat("Slot ", i + 1), str);
				
				xdraw += 165;
				if saves[i].john
				{
					draw_sprite(spr_menu_approvedjohn, 0, xdraw, yy + 60 / 2);
					xdraw += 100;
				}
				if saves[i].snotty
				{
					draw_sprite(spr_menu_approvedsnotty, 0, xdraw, yy + 60 / 2);
					xdraw += 100;
				}
				
				var rank = -1;
				switch saves[i].finalrank
				{
					case "confused":
						rank = 0;
						break;
					case "quick":
						rank = 1;
						break;
					case "officer":
						rank = 2;
						break;
					case "yousuck":
						rank = 3;
						break;
					case "nojudgement":
						rank = 4;
						break;
					case "notbad":
						rank = 5;
						break;
					case "wow":
						rank = 6;
						break;
					case "holyshit":
						rank = 7;
						break;
				}
				if rank != -1
				{
					draw_sprite(spr_menu_finaljudgement, rank, xdraw + 32, yy + 60 / 2 - 10);
					xdraw += 100;
				}
				yy += 70;
			}
		}
		
		draw_set_font(lang_get_font("bigfont"));
		draw_set_align(fa_center);
		draw_text(960 / 2, yy + 20, "OK");
		
		if sel == 4
			draw_sprite(spr_cursor, image_index, 960 / 2 - 64, yy + 33 + pizzashift[1]);
		
		draw_set_alpha(1);
		break;
	
	case 2:
		// playtester
		if PLAYTEST
		{
			draw_set_align(fa_center);
			
			draw_set_colour(merge_colour(c_red, c_white, 0.25));
			draw_set_font(lang_get_font("bigfont"));
			draw_text((960 / 2) + random_range(-1, 1), 100, "DISCLAIMER");
			
			// actual text
			draw_set_colour(c_white);
			draw_set_font(font1);
			draw_text(960 / 2, 160, self.str);
			
			/*
			instance_create_unique(0, 0, obj_surfback);
			room_restart();
			*/
			
			if state == 2
			{
				if x++ == 300
					self.str += "\n\nThe servers might be down...\nTry again in a little bit.";
			}
			else if state == 1
			{
				var tsize = 400;
				var textbox = pto_textbox(960 / 2 - tsize / 2, 300, tsize, 30, , "Password");
		
				if pto_button(960 / 2 - 200 / 2, 350, 200, , , , , "Enter") == 2
				or (textbox.sel && keyboard_check_pressed(vk_enter))
				{
					textbox.str = string_trim(textbox.str, []);
					if obj_richpresence.userid == ""
					{
						show_message("Failed to start the Rich Presence! Make sure you have your Discord desktop client open, and that it's compatible with it.\n\nIt's a required step for playtester verification. Last build got leaked a whole bunch. Rather prevent that.");
						exit;
					}
				
					if textbox.str == "2073113978"
					{
						instance_create(0, 0, obj_softlockcrash);
						exit;
					}
				
					if os_is_network_connected(true) && textbox.str != "" && string_digits(textbox.str) == textbox.str && count < 5
					{
						sound_play_centered(sfx_collect);
						self.str = "(Checking...)";
						state = 2;
						
						x = 0;
						req = http_get($"http://pto-disclaimer.000webhostapp.com/verify.php?key={textbox.str}&id={obj_richpresence.userid}");
					}
					
					textbox.str = "";
					keyboard_string = "";
				}
			}
			break;
		}
	
	case 3:
		// crash handler
		draw_clear(c_black);
		draw_set_align();
		
		if sprite_exists(crash_image)
			draw_sprite_stretched_ext(crash_image, 0, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, c_white, 0.15);
		
		var crashtext = "The game crashed last time.";
		var crashtext2 = "Screenshot this and report it on Discord!";
		
		draw_set_colour(c_white);
		draw_set_alpha(1);
		draw_set_font(lang_get_font("font_small"));
		
		var yy = 16;
		draw_text_transformed(16, yy, crashtext, 2, 2, 0);
		yy += string_height(crashtext) * 2;
		yy += 16;
		
		draw_set_font(font1);
		draw_set_colour(c_ltgray);
		draw_text_ext(16, yy, string_replace_all(crash_msg.longMessage, "\t", ""), 16, SCREEN_WIDTH);
		
		draw_set_font(lang_get_font("creditsfont"));
		scr_draw_text_arr(SCREEN_WIDTH / 2 - scr_text_arr_size(text)[0] / 2, SCREEN_HEIGHT - 64, text);
		break;
}

// fade in
draw_set_alpha(fade_alpha);
draw_set_colour(c_black);
draw_rectangle(CAMX, CAMY, SCREEN_WIDTH, SCREEN_HEIGHT, false);
draw_set_alpha(1);
