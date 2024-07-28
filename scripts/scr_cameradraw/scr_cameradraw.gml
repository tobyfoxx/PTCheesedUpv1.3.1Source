function scr_cameradraw()
{
	if live_call() return live_result;
	
	var player = obj_player1;
	
	var sugary = (player.character == "SP");
	var bo = (player.character == "BN");
	
	if global.kungfu
		draw_sprite(spr_pizzahealthbar, 8 - global.hp, 190, 70);
	
	if (player.state != states.dead)
	{
		var hide = (((MOD.Mirror && player.x > SCREEN_WIDTH - 250) or (!MOD.Mirror && player.x < 250)) && player.y < 169) or manualhide;
		if sugary
			hud_posY = lerp(hud_posY, hide * -300, 0.15);
		else
			hud_posY = Approach(hud_posY, hide * -300, 15);
		
		var cmb = 0;
		if global.hud != 2
		{
			if (global.combo >= 50)
				cmb = 2;
			else if (global.combo >= 25)
				cmb = 1;
		}
		
		if global.heatmeter && cmb < global.stylethreshold
			cmb = global.stylethreshold;
		
		if bo
			cmb = 1;
		
		if REMIX or global.heatmeter 
			pizzascore_index = (pizzascore_index + (0.25 * cmb)) % pizzascore_number;
		else
			pizzascore_index = 0;
		if cmb <= 0
		{
			if floor(pizzascore_index) != 0
				pizzascore_index += 0.35;
			else
				pizzascore_index = 0;
		}
	
		var heatfill = spr_heatmeter_fill;
		var heatmeter = spr_heatmeter;
		var heatpal = spr_heatmeter_palette;
	
		switch player.character
		{
			case "SP":
				heatfill = spr_heatmeter_fillSP;
				heatmeter = spr_heatmeterSP;
				heatpal = spr_heatmeter_paletteSP;
				break;
		}
	
		var sw = sprite_get_width(heatfill);
		var sh = sprite_get_height(heatfill);
		var b = global.stylemultiplier;
		var hud_xx = 121 + irandom_range(-collect_shake, collect_shake);
		var hud_yy = 90 + irandom_range(-collect_shake, collect_shake) + hud_posY;
		
		if global.hud == 2
		{
			hud_xx += 28;
			hud_yy += 15;
		}
		
		if sugary
		{
			hud_xx += 7;
			hud_yy += 6;
		}
		if bo
			hud_yy -= 20;
	
		// heat meter
		if global.heatmeter
		{
			shader_set(global.Pal_Shader);
			pal_swap_set(heatpal, min(global.stylethreshold, 3) + (global.stylethreshold >= 3 && global.style >= 55), false);
			draw_sprite_part(heatfill, pizzascore_index, 0, 0, sw * b, sh, hud_xx - 95, hud_yy + 24);
			draw_sprite_ext(heatmeter, pizzascore_index, hud_xx, hud_yy, 1, 1, 0, c_white, alpha);
			reset_shader_fix();
		}
	
		// score
		var pizzascorespr = spr_pizzascore;
		var peppersprite = spr_pizzascore_pepper;
		var pepperonisprite = spr_pizzascore_pepperoni;
		var olivesprite = spr_pizzascore_olive;
		var shroomsprite = spr_pizzascore_shroom;
	
		if sugary
		{
			pizzascorespr = spr_cakehud;
			peppersprite = spr_cakehud_crank;
			pepperonisprite = spr_cakehud_brank;
			olivesprite = spr_cakehud_arank;
			shroomsprite = spr_cakehud_srank;
		}
		else if bo
		{
			pizzascorespr = spr_pizzascoreBN;
			peppersprite = spr_null;
			pepperonisprite = spr_null;
			olivesprite = spr_null;
			shroomsprite = spr_null;
		}
		draw_sprite_ext(pizzascorespr, pizzascore_index, hud_xx, hud_yy, 1, 1, 0, c_white, alpha);
	
		var _score = global.collect;
		if global.coop
			_score += global.collectN;
	
		if _score >= global.crank
			draw_sprite_ext(peppersprite, pizzascore_index, hud_xx, hud_yy, 1, 1, 0, c_white, alpha);
		if _score >= global.brank
			draw_sprite_ext(pepperonisprite, pizzascore_index, hud_xx, hud_yy, 1, 1, 0, c_white, alpha);
		if _score >= global.arank
			draw_sprite_ext(olivesprite, pizzascore_index, hud_xx, hud_yy, 1, 1, 0, c_white, alpha);
		if _score >= global.srank
			draw_sprite_ext(shroomsprite, pizzascore_index, hud_xx, hud_yy, 1, 1, 0, c_white, alpha);
	
		var rx = hud_xx + 142;
		var ry = hud_yy - 22;
		if sugary
		{
			rx = hud_xx + 119;
			ry = hud_yy - 45;
		}
		scr_rankbubbledraw(rx, ry);
		
		draw_set_align();
		var collectfont = global.collectfont;
		if sugary
			collectfont = global.collectfontSP; 
		else if bo 
			collectfont = global.collectfontBN;
		
		draw_set_font(collectfont);
		var text_y = 0;
		if !bo
		{
			switch floor(pizzascore_index)
			{
				case 1:
				case 2:
				case 3:
					text_y = 1;
					break;
				case 5:
				case 10:
					text_y = -1;
					break;
				case 6:
				case 9:
					text_y = -2;
					break;
				case 7:
					text_y = -3;
					break;
				case 8:
					text_y = -5;
					break;
			}
		}
	
		var cs = 0;
		with obj_comboend
			cs += comboscore;
		with obj_particlesystem
		{
			for (var i = 0; i < ds_list_size(global.collect_list); i++)
				cs += ds_list_find_value(global.collect_list, i).value;
		}
		var sc = _score - global.comboscore - cs;
		if sc < 0
			sc = 0;
		var str = string(sc);
		var num = string_length(str);
		var w = string_width(str);
		
		var xx = hud_xx - (w / 2);
		var yy = hud_yy - 56 + text_y;
		if sugary
		{
			xx -= 6;
			yy -= 11;
		}
		
		if global.hud == 2
		{
			if lastcollect != sc
			{
				color_array = array_create(num);
				for (i = 0; i < num; i++)
					color_array[i] = choose(irandom(3));
				lastcollect = sc;
			}
			shader_set(global.Pal_Shader);
		}
	
		draw_set_alpha(alpha);
		for (i = 0; i < num; i++)
		{
			if sugary
				var yy2 = i % 2 == 0 ? -4 : 0;
			else
			{
				var yy2 = (i + 1) % 2 == 0 ? -5 : 0;
				if global.hud == 2
					pal_swap_set(spr_font_palette, color_array[i], false);
			}
			draw_text(floor(xx), floor(yy + yy2), string_char_at(str, i + 1));
			xx += w / num;
		}
		draw_set_alpha(1);
		pal_swap_reset();
		
		// bullets
		var showbullet = player.character != "V" && player.character != "S" && !player.isgustavo;
		if global.shootstyle == 1 && showbullet
		{
			bulletimage += 0.35;
		
			var bx = hud_xx - 63, by = hud_yy - 16, bpad = 42;
		    var bspr = spr_peppinobullet_collectible;
			
			if global.doublegrab == 3 && player.character != "SN"
				bpad = 25;
			
		    if obj_player1.character == "N"
		    {
		        bx = hud_xx - 69;
		        by = hud_yy + 45;
		        bspr = spr_playerN_noisebomb;
		    }
		
			if global.heatmeter
				by += 32;
		
		    bx += bpad * max(ceil(global.bullet), 3);
		    for (var i = 0; i < max(global.bullet, 3); i++)
		    {
				var a = alpha, img = bulletimage, col = c_white;
				if i >= floor(global.bullet)
				{
					a = 0.25;
					img = 10;
					col = c_black;
				}
			
		        bx -= bpad;
		        draw_sprite_ext(bspr, img, bx, by, 1, 1, 0, col, a);
				if i == floor(global.bullet)
				{
					draw_set_flash();
					draw_sprite_part_ext(bspr, img, 0, 0, 64, 96 * (0.5 + frac(global.bullet) / 2), bx - 32, by, 1, 1, c_white, 0.75);
					draw_reset_flash();
				}
		    }
		}
	
		// chainsaw
		if global.doublegrab == 3 && showbullet && player.character != "SN"
		{
			var bx = hud_xx - 63, by = hud_yy + 60, bpad = 25;
		    var bspr = spr_fuelHUD;
			
			if global.shootstyle != 1
			{
				bulletimage += 0.35;
				bpad = 42;
			}
			else
				bx += 100;
		
			if global.heatmeter
				by += 32;
		
		    bx += bpad * max(ceil(global.fuel), 3);
		    for (i = 0; i < max(global.fuel, 3); i++)
		    {
				var a = alpha, img = bulletimage, col = c_white;
				if i >= floor(global.fuel)
				{
					a = 0.25;
					img = 10;
					col = c_black;
				}
			
		        bx -= bpad;
		        draw_sprite_ext(bspr, img, bx, by, -1, 1, 0, col, a);
			
				if i == floor(global.fuel)
				{
					draw_set_flash();
					draw_sprite_part_ext(bspr, img, 0, 0, 40, 46 * frac(global.fuel), bx - 20, by - 23, 1, 1, c_white, 0.75);
					draw_reset_flash();
				}
		    }
		}
	
		draw_set_font(lang_get_font("bigfont"));
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		
		/*
		if player.character == "V"
		{
			//draw_text(200 + healthshake, 125 + healthshake, global.playerhealth);
			//draw_sprite(spr_pizzaHUD, floor(global.playerhealth / 11), 190, 70);
		}
		*/
		
		if bo or global.hud == 2
		{
			var ix = 41;
			var iy = 150 + hud_posY;
			
			if global.hud == 2
			{
				ix = 50;
				iy = 30;
			}
			
			draw_sprite_ext(spr_inv, image_index, ix, iy, 1, 1, 1, c_white, alpha);
		    if global.key_inv
		        draw_sprite_ext(spr_key, image_index, ix, iy, 1, 1, 1, c_white, alpha);
		}
	}
}
