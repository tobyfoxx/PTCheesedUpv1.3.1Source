function scr_tvdraw()
{
	if live_call() return live_result;
	
	static timer_ind = 0;
	static seconds_prev = "";
	
	if tvreset != global.hud
	{
		tvreset = global.hud;
		targetspr = spr_tv_open;
		state = states.transition;
		sprite_index = spr_tv_idle;
	}
	
	var chara = obj_player1.character;
	
	var sugary = check_sugarychar();
	var bo = chara == "BN";
	
	var tv_x = SCREEN_WIDTH - 115;
	var tv_y = 80;
	
	if global.hud == 2
	{
		tv_x = SCREEN_WIDTH - 127;
		tv_y = 107;
	}
	
	var collect_x = irandom_range(-collect_shake, collect_shake);
	var collect_y = irandom_range(-collect_shake, collect_shake);
	
	// sugary bobbing
	if sugary
	{
		tv_x -= 13;
		tv_y += -6 + Wave(2, -2, 3, 0); // collect_y serves as an offset
	}
	
	// combo
	static combo_shake = 0;
	if REMIX
	{
		static combo_prev = 0;
		if combo_prev != visualcombo
		{
			if combo_prev < visualcombo
				combo_shake = 2;
			combo_prev = visualcombo;
		}
		combo_shake = Approach(combo_shake, 0, 0.15);
	}
	else
		combo_shake = 0;
	
	if global.hud != 2
	{
		if !sugary
		{
			// PIZZA TOWER
			var _cx = tv_x + combo_posX;
			var _cy = tv_y + 117 + hud_posY + combo_posY;
			var _perc = global.combotime / 60;
			var _minX = _cx - 56;
			var _maxX = _cx + 59;
		
			if REMIX
			{
				_cx = round(_cx);
				_cy = round(_cy);
			}
		
			if bo
			{
				combofill_x = lerp(combofill_x, _maxX + ((_minX - _maxX) * _perc), 0.5);
				combofill_y = _cy;
			}
			else
			{	
				combofill_x = lerp(combofill_x, _minX + ((_maxX - _minX) * _perc), 0.5);
				combofill_y = _cy;
			}
	
			var combobubblefill, combobubble, combofont, combofillpalette, combopalette;
			if bo
			{
				combobubblefill = spr_tv_combobubblefillBN;
				combobubble = spr_tv_combobubbleBN;
				combofont = global.combofont2BN;
				
				combofillpalette = spr_tv_combofillpalette;
				combopalette = spr_tv_combopalette;
			
				draw_sprite(spr_tv_combobubblehandBN, image_index, _cx, _cy);
			}
			else
			{
				combobubblefill = spr_tv_combobubblefill;
				combobubble = spr_tv_combobubble;
				combofont = global.combofont2;
				
				combofillpalette = spr_tv_combofillpalette;
				combopalette = spr_tv_combopalette;
			}
			
			pal_swap_set(combofillpalette, (!global.combodropped && global.prank_enemykilled) ? 2 : 1, false);
			draw_sprite(combobubblefill, combofill_index, combofill_x, combofill_y);
			pal_swap_set(combopalette, (scr_ispeppino(obj_player1) && !global.swapmode) ? 0 : 1, false);
			draw_sprite(combobubble, image_index, _cx, _cy);
			
			draw_set_font(combofont);
			draw_set_align(0);
	
			var _tx = _cx - 64;
			var _ty = _cy - 12;
		
			var _str = string(visualcombo);
			var num = string_length(_str);
			for (var i = num; i > 0; i--)
			{
				var char = string_char_at(_str, i);
				draw_text(_tx + random_range(-combo_shake, combo_shake), _ty + random_range(-combo_shake, combo_shake), char);
				_tx -= 22;
				_ty -= 8;
			}
			pal_swap_reset();
		}
		else
		{
			// sugary combo
			var _cx = tv_x + combo_posX - 170 - 13;
			var _cy = tv_y + 16 + 6 + hud_posY + combo_posY;
			var _hy = hand_y;
	
			var _perc = global.combotime / 60;
			if global.combo <= 0
			{
				hand_x = Approach(hand_x, 80, 8);
				hand_y = Approach(hand_y, -32, 8);
				_hy = 50;
			}
			else if _cy > -150
			{
				hand_x = lerp(hand_x, 0, 0.15);
				hand_y = lerp(hand_y, lerp(35, -30, _perc), 0.25);
			}
	
			var xx = (_cx - 50) + (-3 + 50);
			var yy = (_cy - 91) + (_hy + 100);
		
			draw_reset_clip();
			draw_set_mask(_cx - 50, _cy - 91, spr_tv_combometercutSP);
			draw_sprite(spr_tv_combometergooSP, propeller_index, xx, yy);
			draw_reset_clip();
			
			draw_sprite(spr_tv_combobubbleSP, image_index, _cx, _cy);
			draw_sprite(spr_tv_combometerhandSP, image_index, _cx + hand_x + 80, max(_cy, 60 + hud_posY) + min(hand_y, 20) + 24);
			
			draw_set_font(global.combofontSP);
			draw_set_align(fa_center);
			draw_set_color(c_white);
			draw_text(_cx, _cy - 90, string(visualcombo) + "x");
		}
	}

	if (room != strongcold_endscreen)
	{
		// background
		if SUGARY or (check_sugary() && instance_exists(obj_ghostcollectibles))
		{
			// secrets
			var bgindex = tv_bg_index, bgcol = c_white;
			if instance_exists(obj_ghostcollectibles)
				bgindex = 9; //SUGARY ? 9 : 20;
			if obj_player1.state == states.secretenter && instance_exists(obj_fadeout)
				bgcol = merge_color(c_white, c_black, clamp(obj_fadeout.fadealpha, 0, 1));
			
			// decide sprite
			var sprite = global.panic ? spr_tv_bgescape_ss : spr_tv_bgfinal_ss;
			if sugary
				sprite = global.panic ? spr_tv_bgescape_ssSP : spr_tv_bgfinal_ssSP;
			
			// draw
			draw_sprite_ext(sprite, bgindex, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, bgcol, alpha);
			
			// flash white
			if instance_exists(obj_hungrypillarflash)
			{
				draw_set_flash(c_white);
				draw_sprite_ext(sprite, bgindex, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, obj_hungrypillarflash.fade * alpha);
				draw_reset_flash();
			}
		}
		else if REMIX && sprite_exists(tv_bg.sprite)
		{
			toggle_alphafix(true);
			
			// secrets
			var bgindex = tv_bg.sprite, bgcol = c_white;
			if instance_exists(obj_ghostcollectibles)
				bgindex = sugary ? bg_secret_ss : spr_gate_secretBG;
			if obj_player1.state == states.secretenter && instance_exists(obj_fadeout) && global.leveltosave != "secretworld"
				bgcol = merge_color(c_white, c_black, clamp(obj_fadeout.fadealpha, 0, 1));
			
			// move it
			var movespeed// = -obj_player1.hsp / 15;
			//if round(movespeed) == 0
				movespeed = -0.25;
			
			tv_bg.x += movespeed;
			if !surface_exists(tv_bg.surf)
				tv_bg.surf = surface_create(278, 268);
			
			// draw it
			surface_set_target(tv_bg.surf);
			
			for(var i = 0; i < sprite_get_number(bgindex); i++)
				draw_sprite_tiled(bgindex, i, 278 / 2 + tv_bg.x * max(lerp(-1, 1, tv_bg.parallax[i]), 0), 268);
			
			gpu_set_blendmode(bm_subtract);
			draw_sprite(sugary ? spr_tv_clipSP : spr_tv_clip, 1, 278 / 2, 268 - tv_bg.y);
			gpu_set_blendmode(bm_normal);
			
			surface_reset_target();
			
			if PANIC && global.panicbg
			{
				shader_set(shd_panicbg);
				var panic_id = shader_get_uniform(shd_panicbg, "panic");
				shader_set_uniform_f(panic_id, clamp(global.wave / global.maxwave, -0.5, 1));
				var time_id = shader_get_uniform(shd_panicbg, "time");
				shader_set_uniform_f(time_id, (scr_current_time() / 1000) % (pi * 6));
			}
			draw_surface_ext(tv_bg.surf, tv_x + collect_x - 278 / 2, tv_y + collect_y + hud_posY - 268 + tv_bg.y, 1, 1, 0, bgcol, alpha);
			shader_reset();
			
			toggle_alphafix(false);
		}
		else
		{
			var tv_bg_sprite = spr_tv_bgfinal;
			if sugary
				tv_bg_sprite = spr_tv_bgfinalSP;
				
			draw_sprite_ext(tv_bg_sprite, tv_bg_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
		}
		
		// april background
		if global.hud == 2 && !sugary
			draw_sprite(spr_tv_aprilbg, 1, tv_x + collect_x, tv_y + collect_y + hud_posY);
		
		// player
		var tv_palette = 0;
		if chara == "N"
			tv_palette = 1;
		if chara == "V"
			tv_palette = 2;
		
		pal_swap_player_palette();
		draw_sprite_ext(sprite_index, image_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
		
		// noise jetpack
		var _red = global.noisejetpack && (scr_ispeppino(obj_player1) || obj_player1.noisepizzapepper);
		if _red
		{
			cuspal_reset();
			pal_swap_set(obj_player1.spr_palette, 2, false);
			draw_sprite_ext(sprite_index, image_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
		}
		pal_swap_reset();
		
		// tv frame palette
		if tv_palette != 0
		{
			pal_swap_set(spr_tv_palette, tv_palette, false);
			var spr = spr_tv_empty;
			if sprite_index == spr_tv_open
				spr = sprite_index;
			draw_sprite_ext(spr, image_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
		}
		
		// static
		if (state == states.tv_whitenoise)
		{
			pal_swap_set(spr_tv_palette, tv_palette, false);
			
			if sugary
				var charspr = spr_tv_whitenoiseSP;
			else
				var charspr = SPRITES[? "spr_tv_whitenoise" + chara];
			draw_sprite(charspr ?? spr_tv_whitenoise, tv_trans, tv_x + collect_x, tv_y + collect_y + hud_posY);
		}
		
		// noise coming out of the tv has an edge case
		if sprite_index == spr_tv_exprheatN
		{
			pal_swap_player_palette();
			draw_sprite_ext(sprite_index, image_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
			
			if _red
			{
				cuspal_reset();
				pal_swap_set(obj_player1.spr_palette, 2, false);
				draw_sprite_ext(sprite_index, image_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
			}
		}
		pal_swap_reset();
		
		// propeller
		if sugary && targetspr != spr_tv_off && targetspr != spr_tv_open
		{
			propeller_index += 0.35;
			draw_sprite_ext(spr_pizzytvpropeller, propeller_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
		}
		
		// april combo
		if global.hud == 2
		{
			if (global.combo != 0 && sprite_index != spr_tv_open && sprite_index != spr_tv_off)
			{
			    draw_sprite_ext(spr_tv_combo, image_index, tv_x + collect_x, tv_y + collect_y + hud_posY, 1, 1, 0, c_white, alpha);
	    
				var str = string(global.combo);
			    if global.combo < 10
			        str = concat("0", str);
		
			    draw_set_align();
			    draw_set_font(global.combofont);
			    var num = string_length(str);
			    var w = string_width(str) / num;
			    var xx = 0, yy = 0;
			    for (var i = 0; i < num; i++)
			    {
			        var char = string_char_at(str, i + 1);
			        xx = (i * w) + random_range(-combo_shake, combo_shake);
			        yy = (i * 5) + random_range(-combo_shake, combo_shake);
			        draw_text(SCREEN_WIDTH - 171 + xx, 91 - yy + hud_posY, char);
			    }
				
				// combotime
				var barxx = SCREEN_WIDTH - 128 + -26;
				var baryy = 250 + 30;
				draw_sprite(spr_barpop, 0, barxx, baryy);
				var sw = sprite_get_width(spr_barpop);
				var sh = sprite_get_height(spr_barpop);
				var b = (global.combotime / 55);
				draw_sprite_part(spr_barpop, 1, 0, 0, sw * b, sh, barxx, baryy);
			}
		}
	}
	
	// bubble prompt
	if (bubblespr != noone)
		draw_sprite_ext(bubblespr, bubbleindex, SCREEN_WIDTH - 448, 53, 1, 1, 1, c_white, alpha);
	if (!surface_exists(promptsurface))
		promptsurface = surface_create(290, 102);
	surface_set_target(promptsurface);
	draw_clear_alpha(0, 0);
	draw_set_font(font1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	if (bubblespr == spr_tv_bubble)
	{
		promptx -= promptspd;
		if (bubblespr != spr_tv_bubbleclose && promptx < (350 - string_width(prompt)))
		{
			bubblespr = spr_tv_bubbleclose;
			bubbleindex = 0;
		}
		draw_text_color(promptx - 350, 50, prompt, c_black, c_black, c_black, c_black, 1);
	}
	draw_set_halign(fa_left);
	surface_reset_target();
	draw_surface(promptsurface, SCREEN_WIDTH - 610, 0);
	draw_set_font(global.smallnumber_fnt);
	draw_set_halign(fa_center);

	if (global.panic or global.snickchallenge) && !MOD.DeathMode
	{
		// smooth timer
		var gaining_time = true;
		
		if global.fill <= fill_lerp
		{
			fill_lerp = global.fill;
			gaining_time = false;
		}
		else if global.leveltosave == "sucrose"
			fill_lerp = Approach(fill_lerp, global.fill, 2);
		else
			fill_lerp = lerp(fill_lerp, global.fill, 0.25);
	
		// chunk timer
		var _fill = fill_lerp;
		var _currentbarpos = chunkmax - _fill;
		_perc = _currentbarpos / chunkmax;
		var _max_x = 299;
		var _barpos = _max_x * _perc;
	
		// M:SS timer
		var minutes = 0;
		for (var seconds = ceil(_fill / 12); seconds > 59; seconds -= 60)
			minutes++;
		if (seconds < 10)
			seconds = concat("0", seconds);
		else
			seconds = string(seconds);
	
		// draw them
		if !sugarylevel
		{
			var bar = spr_timer_bar;
			var barfill = spr_timer_barfill;
			var timerspr = timer_tower && global.lapmode != lapmode.laphell ? spr_timer_tower : pizzaface_sprite;
			johnface_sprite = spr_timer_johnface;
			
			if bolevel
			{
				bar = spr_timer_barBN;
				barfill = spr_timer_barfillBN;
				johnface_sprite = spr_timer_johnfaceBN;
			
				if timerspr == spr_timer_pizzaface1
					timerspr = spr_timer_pizzaface1BN;
				else
					timerspr = spr_timer_pizzaface2BN;
			}
			shader_reset();
			
			var _barfillpos = floor(_barpos) + 13;
			if _barfillpos > 0
			{
				var clip_x = timer_x + 3;
				var clip_y = timer_y + 5;
				draw_set_bounds(clip_x, clip_y, clip_x + _barfillpos, clip_y + 30);
				for (i = 0; i < 3; i++)
					draw_sprite(barfill, 0, clip_x + barfill_x + (i * 173), clip_y);
				
				draw_reset_clip();
			}
			draw_sprite(bar, image_index, timer_x, timer_y);
		
			// john
			draw_sprite(johnface_sprite, johnface_index, timer_x + 13 + max(_barpos, 0), timer_y + 20);
		
			// pizzaface
			if !global.snickchallenge
				draw_sprite(timerspr, pizzaface_index, timer_x + 320, timer_y + 10);
			
			// timer
			draw_set_align(1, 1);
			draw_set_font(lang_get_font("bigfont"));
			draw_text(timer_x + 153, timer_y + 18 - (font_get_offset(global.bigfont).y / 2), concat(minutes, ":", seconds));
		}
		else if global.leveltosave == "sucrose"
		{
			// sucrose snowstorm
			if pizzaface_sprite == spr_timer_pizzaface1
				draw_sprite(spr_sucrosetimer_coneball_idle, pizzaface_index, SCREEN_WIDTH / 2, timer_y + 25);
			if pizzaface_sprite == spr_timer_pizzaface2
				draw_sprite(spr_sucrosetimer_coneball, pizzaface_index, SCREEN_WIDTH / 2, timer_y + 25);
			if pizzaface_sprite == spr_timer_pizzaface3
				draw_sprite(spr_sucrosetimer_coneball, 25, SCREEN_WIDTH / 2, timer_y + 25);
			
			if seconds_prev != seconds
			{
				timer_ind = timer_ind ? 0 : 1;
				seconds_prev = seconds;
			}
			
			var _tmr_spr = gaining_time ? spr_sucrosetimer_gain : spr_sucrosetimer;
			draw_sprite(_tmr_spr, timer_ind, SCREEN_WIDTH / 2, timer_y + 25);
			
			// text
			var minsx = SCREEN_WIDTH / 2 - 90
			var secx = SCREEN_WIDTH / 2 - 10
			var minsy = timer_y + 25 - 15
			
			if minutes < 10
				minutes = concat("0", minutes);
			minutes = string(minutes);
			
			var col = gaining_time ? #60D048 : #F80000;
			
			draw_sprite_ext(spr_sucrosetimer_font, ord(string_char_at(minutes, 1)) - ord("0"), minsx, minsy, 1, 1, 0, col, 1);
			draw_sprite_ext(spr_sucrosetimer_font, ord(string_char_at(minutes, 2)) - ord("0"), minsx + 28, minsy, 1, 1, 0, col, 1);
			
			draw_sprite_ext(spr_sucrosetimer_font, ord(string_char_at(seconds, 1)) - ord("0"), secx, minsy, 1, 1, 0, col, 1);
			draw_sprite_ext(spr_sucrosetimer_font, ord(string_char_at(seconds, 2)) - ord("0"), secx + 28, minsy, 1, 1, 0, col, 1);
		}
		else
		{
			// sugary spire
			if pizzaface_sprite == spr_timer_pizzaface1
			{
				draw_sprite(spr_bartimer_normalBack, pizzaface_index, timer_x + 164, timer_y + 20);
				
				var _barfillpos = floor(_barpos) + 13;
				if (_barfillpos > 0)
				{
					var clipx = timer_x - 20;
					var clipy = timer_y + 20;
					
					draw_set_bounds(clipx, clipy, clipx + _barfillpos, clipy + 50);
					draw_sprite(spr_bartimer_strip, 0, clipx + 184, clipy);
					draw_reset_clip();
				}
				draw_sprite(spr_bartimer_roll, johnface_index, max(timer_x + _barfillpos, timer_x) - 24, timer_y + 55 - 15 * max(_perc, 0));
		
				draw_sprite(spr_bartimer_normalFront, pizzaface_index, timer_x + 164, timer_y + 20);
			}
			else if pizzaface_sprite == spr_timer_pizzaface2
				draw_sprite(spr_bartimer_showtime, pizzaface_index, timer_x + 164, timer_y + 20);
			else if pizzaface_sprite == spr_timer_pizzaface3
				draw_sprite(spr_bartimer_showtime, 70, timer_x + 164, timer_y + 20);
		
			// timer
			draw_set_align(1, 1);
			draw_set_font(lang_get_font("sugarypromptfont"));
			draw_text(timer_x + 153, timer_y, concat(minutes, ":", seconds));
		}
		
		// lap display
		if global.lap > 0
		{
			if !instance_exists(obj_ghostcollectibles) && global.leveltosave != "sucrose" && global.leveltosave != "secretworld"
				lap_y = Approach(lap_y, timer_ystart + 24 * sugarylevel, 1);
			else
				lap_y = Approach(lap_y, timer_ystart + 212, 4);
				
			if instance_exists(obj_wartimer)
				lap_x = Approach(lap_x, (SCREEN_WIDTH / 2) - 170 + (50 * sugarylevel), 1);
			else if !instance_exists(obj_pizzaface) or showtime_buffer > 0
				lap_x = timer_x - 32 * sugarylevel;
			else
				lap_x = Approach(lap_x, (SCREEN_WIDTH / 2) + 32, 1);
			
			draw_lapflag(lap_x, lap_y, lapflag_index, sugarylevel);
		}
	}

	draw_set_align();
}
