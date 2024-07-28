function scr_tvdraw_old()
{
	//if live_call() return live_result;
	
	var panicy = 600 + (string_height(message) - 16);
	var tvx = SCREEN_WIDTH - 128 + irandom_range(-obj_camera.collect_shake, obj_camera.collect_shake);
	var tvy = 74 + irandom_range(-obj_camera.collect_shake, obj_camera.collect_shake);
	
	static comboprev = 0;
	
	if tvreset != global.hud
	{
		alarm[0] = -1;
		tvreset = global.hud;
		imageindexstore = 0;
		once = false;
		yi = panicy;
		showtext = false;
		tvsprite = spr_tvdefault;
		image_speed = 0.1;
	}
	
	#region SPRITE
	
	alpha = 1;
	if (instance_exists(obj_player1) && obj_player1.y < camera_get_view_y(view_camera[0]) + 200 && obj_player1.x > camera_get_view_x(view_camera[0]) + SCREEN_WIDTH - 200)
	or obj_camera.manualhide
		alpha = 0.5;
	
	if instance_exists(obj_itspizzatime)
	{
		message = "GET TO THE EXIT!!";
		alarm[0] = 200;
		showtext = true;
		tvsprite = spr_tvexit;
		image_speed = 0.25;
	}
	
	/*
	else if ((global.collect >= global.srank && !shownranks)
	or (global.collect >= global.arank && !shownranka)
	or (global.collect >= global.brank && !shownrankb)
	or (global.collect >= global.crank && !shownrankc))
	&& !global.snickchallenge
	{
		if !REMIX
			image_index = 0;
		
		image_speed = REMIX ? 0.1 : 0;
		showtext = true;
		alarm[0] = 200;
		
		if !shownrankc
		{
			message = "YOU GOT ENOUGH FOR RANK C!";
			tvsprite = spr_tvrankc;
			shownrankc = true;
		}
		else if !shownrankb
		{
			message = "YOU GOT ENOUGH FOR RANK B!";
			tvsprite = spr_tvrankb;
			shownrankb = true;
		}
		else if !shownranka
		{
			message = "YOU GOT ENOUGH FOR RANK A!";
			tvsprite = spr_tvranka;
			shownranka = true;
		}
		else if !shownranks && REMIX
		{
			message = "YOU GOT ENOUGH FOR RANK S!!!";
			tvsprite = spr_tvranks;
			shownranks = true;
		}
	}
	*/
	
	// good job you don't in fact suck
	else if instance_exists(obj_player1) && obj_player1.sprite_index == obj_player1.spr_levelcomplete
	{
		alarm[0] = 50
		tvsprite = spr_tvclap
		once = true
	}
	
	// owie moans in pain uwu
	else if instance_exists(obj_player1) && obj_player1.state == states.hurt 
	{
		if !once
			message = choose("OW!", "OUCH!", "OH!", "WOH!")
		
		showtext = true
		alarm[0] = 50
		tvsprite = spr_tvhurt
		once = true
	}
	
	// skull emoji face ass
	else if instance_exists(obj_player1) && (obj_player1.state == states.timesup or obj_player1.state == states.ejected)
	{
		alarm[0] = 50
		tvsprite = spr_tvskull
	}
	
	// combo
	else if global.combo != comboprev && (tvsprite == spr_tvdefault or tvsprite == spr_tvcombo or tvsprite == spr_tvescape)
	{
		if global.combo == 0
		{
			if obj_player1.state == states.comingoutdoor
				event_perform(ev_alarm, 0);
			else
			{
				tvsprite = spr_tvcomboresult;
				image_speed = 0;
				image_index = min(comboprev, 3);
				alarm[0] = 50;
			}
		}
		else
		{
			tvsprite = spr_tvcombo;
			imageindexstore = global.combo - 1;
			
			if REMIX
				alarm[0] = 80;
		}
		comboprev = global.combo;
	}
	
	if instance_exists(obj_player1) && obj_player1.state == states.keyget
	{
		showtext = true
		message = "GOT THE KEY!"
		alarm[0] = 50
	}
	
	#endregion
	#region DRAW
	
	var sugary = check_char("SP") or check_char("SN");
	var sprite = tvsprite, def = spr_tvdefault, combo = spr_tvcombo;
	
	if sugary
	{
		var def = spr_tvdefault_ss, combo = spr_tvcombo_ss;
		sprite = SPRITES[? sprite_get_name(tvsprite) + "_ss"] ?? def;
	}
	
	if global.combo > 0 && global.combotime > 0 && (tvsprite == spr_tvcombo or tvsprite == spr_tvdefault)
	{
		// combo tv
		var wd = 16 + (global.combotime / 60) * sprite_get_width(sprite);
			
		draw_sprite_part_ext(def, image_index, wd, 0, sprite_get_width(sprite), sprite_get_height(sprite), tvx + wd - sprite_get_xoffset(sprite), tvy - sprite_get_yoffset(sprite), 1, 1, c_white, alpha);
		draw_sprite_part_ext(combo, global.combo - 1, 0, 0, wd, sprite_get_height(sprite), tvx - sprite_get_xoffset(sprite), tvy - sprite_get_yoffset(sprite), 1, 1, c_white, alpha);
		
		// propeller
		if sugary
			draw_sprite_ext(spr_tvempty_ss, image_index, tvx, tvy, 1, 1, 0, c_white, alpha);
	}
	else
		draw_sprite_ext(sprite, image_index, tvx, tvy, 1, 1, 0, c_white, alpha);
	
	draw_set_align(fa_center);
	if tvsprite == spr_tvcombo
	{
		draw_sprite_ext(sugary ? spr_tvcomboclear_ss : spr_tvcomboclear, 0, tvx, tvy, 1, 1, 0, c_white, alpha);
		draw_text_new(tvx + 20, tvy + 1, string(global.combo));
	}
	if tvsprite == spr_tvdefault
		draw_text_new(tvx - 4, tvy - 14, string(global.collect));
	draw_set_alpha(1);
	
	// Text Event
	/*
	xi = (SCREEN_WIDTH / 2) + random_range(1, -1);
	if showtext
		yi = Approach(yi, SCREEN_HEIGHT - 8, 5);
	else
		yi = Approach(yi, panicy, 1);
	
	draw_set_font(lang_get_font("bigfont"));
	draw_set_align(fa_center, fa_bottom);
	draw_set_color(c_white);
	draw_text(xi, yi, string(message));
	draw_set_align();
	*/
	
	// timer
	if PANIC && !MOD.DeathMode
	{
		var minutes = 0;
		for (var seconds = ceil(global.fill / 12); seconds > 59; seconds -= 60)
			minutes++;
	
		draw_set_align(1, 1);
		draw_set_font(lang_get_font("bigfont"));
		draw_set_colour(minutes == 0 && seconds < 30 ? c_red : c_white);
		draw_text_new(timer_x + 153 + random_range(-1, 1), timer_y + 18 + random_range(-1, 1), concat(minutes, ":", (seconds < 10 ? "0" : "") + string(seconds)));
		
		// lap display
		if global.lap > 0
		{
			if !instance_exists(obj_ghostcollectibles)
				lap_y = Approach(lap_y, timer_ystart, 1);
			else
				lap_y = Approach(lap_y, timer_ystart + 212, 4);
			
			if instance_exists(obj_wartimer)
				lap_x = Approach(lap_x, (SCREEN_WIDTH / 2) - 170 + (50 * sugarylevel), 2);
			else if !instance_exists(obj_pizzaface) or showtime_buffer > 0
				lap_x = timer_x + 85;
			else
				lap_x = Approach(lap_x, (SCREEN_WIDTH / 2) + 32, 1);
			
			draw_lapflag(lap_x, lap_y, lapflag_index, sugarylevel);
		}
	}
	
	// bullets
	if global.shootstyle == 1 && obj_player1.character != "V" && obj_player1.character != "S"
	{
		var bx = 780, by = 130, bpad = 10;
		var bspr = spr_bulletHUD;
		
		bx += bpad * max(ceil(global.bullet), 3);
		for (var i = 0; i < max(global.bullet, 3); i++)
		{
			var a = alpha, col = c_white;
			if i >= floor(global.bullet)
			{
				a = 0.25;
				col = c_black;
			}
			
		    bx -= bpad;
		    draw_sprite_ext(bspr, 0, bx, by, 1, 1, 0, col, a);
			if i == floor(global.bullet)
			{
				draw_set_flash();
				draw_sprite_part_ext(bspr, 0, 0, 0, 64, 37 * frac(global.bullet), bx - 10, by - 18, 1, 1, c_white, 0.75);
				draw_reset_flash();
			}
		}
	}
	
	// chainsaw
	if global.doublegrab == 3 && obj_player1.character != "V" && obj_player1.character != "S"
	{
		var bx = 860, by = 130, bpad = 15;
		var bspr = spr_fuelHUD;
		
		bx += bpad * max(ceil(global.fuel), 3);
		for (i = 0; i < max(global.fuel, 3); i++)
		{
			var a = alpha, col = c_white;
			if i >= floor(global.fuel)
			{
				a = 0.25;
				col = c_black;
			}
			
		    bx -= bpad;
		    draw_sprite_ext(bspr, 0, bx, by, 1, 1, 0, col, a);
			
			if i == floor(global.fuel)
			{
				draw_set_flash();
				draw_sprite_part_ext(bspr, 0, 0, 0, 40, 46 * frac(global.fuel), bx - 20, by - 23, 1, 1, c_white, 0.75);
				draw_reset_flash();
			}
		}
	}
	
	#endregion
}
