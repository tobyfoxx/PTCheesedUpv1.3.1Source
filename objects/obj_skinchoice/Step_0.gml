live_auto_call;

if !init
	exit;
event_inherited();

if submenu == 0
{
	#region MOVE
	
	if anim_con != 2 switch sel.side
	{
		// CHARACTER
		case 0:
			handx = lerp(handx, SCREEN_WIDTH / 2 - 50, 0.25);
			handy = lerp(handy, -200, 0.1);
	
			if move_hor != 0
			{
				if move_hor == -1 && !DEBUG
				{
					sideoffset = 10;
					fmod_event_instance_set_parameter(global.snd_golfjingle, "state", 0, true);
					fmod_event_instance_play(global.snd_golfjingle);
					exit;
				}
				
				sel.side = move_hor == 1 ? 1 : 2;
				if sel.side == 2
					sel.pal = 0;
				trace(sel);
				sound_play(sfx_angelmove);
		
				flashpal[0] = sel.pal;
				flashpal[1] = 4;
			}
			if move_ver != 0
			{
				var prevpal = sel.char;
				sel.char = clamp(sel.char + move_ver, 0, array_length(characters) - 1);
	
				if sel.char != prevpal
				{
					skin_tip = 0;
			
					charshift[1] = move_ver;
					charshift[2] = 0; // alpha
			
					mixing = false;
					sel.mix = 0;
			
					sound_play(sfx_angelmove);
					event_user(0);
				}
			}
			break;
	
		// PALETTE
		case 1:
			if move_hor == -1 && sel.pal % 13 == 0 && !mixing
			{
				sel.side = 0;
				event_user(0);
				sound_play(sfx_angelmove);
			}
			else
			{
				if !mixing
				{
					var prevpal = sel.pal;
					if (sel.pal % 13 != 12 or move_hor == -1) && sel.pal + move_hor < array_length(palettes)
						sel.pal += move_hor;
		
					if sel.pal + move_ver * 13 >= 0 && sel.pal + move_ver * 13 < array_length(palettes)
						sel.pal += move_ver * 13;
		
					if sel.pal != prevpal
					{
						charshift[0] = -0.75;
						charshift[2] = 0; // alpha
						sound_play(sfx_angelmove);
		
						flashpal[0] = sel.pal;
						flashpal[1] = 4;
					}
					
					if palettes[sel.pal].texture == noone
					{
						sel.mix = 0;
						mixing = false;
					}
				}
				else
				{
					var prevpal = sel.mix;
					if (sel.mix % 13 != 12 or move_hor == -1) && sel.mix + move_hor < array_length(mixables) && sel.mix + move_hor >= 0
						sel.mix += move_hor;
		
					if sel.mix + move_ver * 13 >= 0 && sel.mix + move_ver * 13 < array_length(mixables)
						sel.mix += move_ver * 13;
		
					if sel.mix != prevpal
					{
						charshift[0] = -0.75;
						charshift[2] = 0; // alpha
						sound_play(sfx_angelmove);
				
						flashpal[0] = sel.mix;
						flashpal[1] = 4;
					}
				}
			}
			break;
	
		// CUSTOM
		case 2:
			if move_hor == 1 && (sel.pal % 13 == 12 or sel.pal + 1 > array_length(custom_palettes))
			{
				sel.side = 0;
				event_user(0);
				sound_play(sfx_angelmove);
			}
			else
			{
				var prevpal = sel.pal;
				if (sel.pal % 13 != 0 or move_hor == 1) && sel.pal + move_hor < array_length(custom_palettes) + 1
					sel.pal += move_hor;
		
				if sel.pal + move_ver * 13 >= 0 && sel.pal + move_ver * 13 < array_length(custom_palettes) + 1
					sel.pal += move_ver * 13;
				
				if sel.pal != prevpal
				{
					charshift[0] = 0.75;
					charshift[2] = 0; // alpha
					sound_play(sfx_angelmove);
					
					flashpal[0] = sel.pal;
					flashpal[1] = 4;
				}
				
				if key_jump
				{
					submenu = 1;
					sel.pal = 0;
					
					var color_count = characters[sel.char].color_count;
					if color_count == noone
						color_count = sprite_get_height(characters[sel.char].spr_palette);
					
					for(var i = 0; i < color_count; i++)
					{
						var col = pal_swap_get_pal_color(characters[sel.char].spr_palette, 0, i);
						var r = colour_get_red(col);
						var g = colour_get_green(col);
						var b = colour_get_blue(col);
						
						custom_palette[i * 4] = r / 255;
						custom_palette[i * 4 + 1] = g / 255;
						custom_palette[i * 4 + 2] = b / 255;
						custom_palette[i * 4 + 3] = 1;
					}
				}
			}
			break;
	}

	if flashpal[1] > 0
		flashpal[1]--;
	else
		flashpal[0] = -1;

	#endregion
	#region palette mixing

	mixing = false;
	if array_length(mixables) > 1 && sel.side == 1 && palettes[sel.pal].texture != noone
	{
		create_transformation_tip(lstr("mixingtip"), "palettemixing");
		mixing = key_attack;
	}
	mixingfade = Approach(mixingfade, mixing, 0.3);

	#endregion

	// charshifts
	charshift[0] = lerp(charshift[0], 0, 0.25); // horizontal
	charshift[1] = lerp(charshift[1], 0, 0.25); // vertical
	charshift[2] = lerp(charshift[2], 1, 0.25); // alpha

	// toggle noise pogo
	if characters[sel.char].char == "N" && global.sandbox
	{
		if check_char("N")
			create_transformation_tip(lstr("noisetypetip"), "noisetype");
		if key_taunt2
		{
			sound_play(sfx_step);
			noisetype = !noisetype;
		}
	}
}
else if submenu == 1 && anim_con != 2
{
	mixingfade = 0;
	if move_ver != 0
	{
		var color_count = characters[sel.char].color_count;
		if color_count == noone
			color_count = sprite_get_height(characters[sel.char].spr_palette);
		
		var prev = sel.pal;
		sel.pal = clamp(sel.pal + move_ver, 0, color_count - 1);
		
		if sel.pal != prev
		{
			
		}
	}
	
	// cancel
	if key_back && anim_con == 0
	{
		close_menu();
		sound_play(sfx_back);
		anim_con = 1;
	}
}

/*
if DEBUG && keyboard_check_pressed(ord("S"))
{
	var st = {};
	for(var i = 0; i < array_length(characters); i++)
	{
		sel.char = i;
		event_user(0);
		
		for(var j = 0; j < array_length(palettes); j++)
		{
			palettes[j].color = noone;
			if palettes[j].texture != noone
			{
				palettes[j].palette = sprite_get_name(palettes[j].texture);
				palettes[j].texture = noone;
			}
		}
		
		struct_set(st, characters[sel.char][0], palettes);
	}
	clipboard_set_text(json_stringify(st, true));
}
*/
