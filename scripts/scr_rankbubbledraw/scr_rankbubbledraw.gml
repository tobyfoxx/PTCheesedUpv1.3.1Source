function scr_rankbubbledraw(rx, ry)
{
	if hud_is_hidden(true)
		exit;
	
	var sugary = check_sugarychar();
	var bo = (obj_player1.character == "BN");
	
	var _score = global.collect;
	var rank_ix = 0;
	
	if _score >= global.srank && scr_is_p_rank()
	{
		rank_ix = 5;
		
		// shake
		if REMIX && global.combotime < 15
		{
			rx += random_range(-2, 2);
			ry += random_range(-2, 2);
		}
	}
	else if _score >= global.srank
		rank_ix = 4;
	else if _score >= global.arank
		rank_ix = 3;
	else if _score >= global.brank
		rank_ix = 2;
	else if _score >= global.crank
		rank_ix = 1;
	
	if previousrank != rank_ix
	{
		var _snd = global.snd_rankup;
		previousrank = rank_ix;
		if rank_ix < previousrank
			_snd = global.snd_rankdown;
		fmod_event_instance_play(_snd);
		fmod_event_instance_set_parameter(_snd, "state", rank_ix - 1, true);
		rank_scale = 3;
	}
	rank_scale = Approach(rank_scale, 1, 0.2);
	
	var ranksprite = REMIX ? spr_ranks_hud_NEW : spr_ranks_hud;
	if MOD.DeathMode
		ranksprite = !SUGARY ? spr_ranks_death : spr_ranks_deathss;
	else if sugary
		ranksprite = spr_ranks_hudSP;
	else if bo
		ranksprite = spr_ranks_hudBN;
	draw_sprite_ext(ranksprite, rank_ix, rx, ry, rank_scale, rank_scale, 0, c_white, 1);
	
	var spr_w = sprite_get_width(ranksprite);
	var spr_h = sprite_get_height(ranksprite);
	var spr_xo = sprite_get_xoffset(ranksprite);
	var spr_yo = sprite_get_yoffset(ranksprite);
	
	if !global.snickchallenge
	{
		var perc = 0;
		switch rank_ix
		{
			case 4:
			case 5:
				perc = 0;
				break;
			case 3:
				perc = (_score - global.arank) / (global.srank - global.arank);
				break;
			case 2:
				perc = (_score - global.brank) / (global.arank - global.brank);
				break;
			case 1:
				perc = (_score - global.crank) / (global.brank - global.crank);
				break;
			default:
				perc = _score / global.crank;
		}
	
		var t = spr_h * perc;
		var top = spr_h - t;
		var rankfillsprite = REMIX ? spr_ranks_hudfill_NEW : spr_ranks_hudfill;
		
		if MOD.DeathMode
			rankfillsprite = !SUGARY ? spr_ranks_deathfill : spr_ranks_deathfillss;
		else if sugary
			rankfillsprite = spr_ranks_hudfillSP;
		else if bo
			rankfillsprite = spr_ranks_hudfillBN;
		
		if rank_scale == 1 or !REMIX
			draw_sprite_part(rankfillsprite, rank_ix, 0, top, spr_w, spr_h - top, rx - spr_xo, (ry - spr_yo) + top);
	}
	else
	{
		var perc = 0;
		switch rank_ix
		{
			case 5:
			case 4:
				perc = (10000 - _score) / (10000 - global.srank);
				break;
			case 3:
				perc = (global.srank - _score) / (global.srank - global.arank);
				break;
			case 2:
				perc = (global.arank - _score) / (global.arank - global.brank);
				break;
			case 1:
				perc = (global.brank - _score) / (global.brank - global.crank);
				break;
		}
	
		var t = spr_h * perc;
		var rankfillsprite = REMIX ? spr_ranks_hudrev_NEW : spr_ranks_hudrev;
		if sugary
			rankfillsprite = spr_ranks_hudrevSP;
		else if bo
			rankfillsprite = spr_ranks_hudrevBN;
		
		if rank_scale == 1
			draw_sprite_part(rankfillsprite, rank_ix, 0, 0, spr_w, t, rx - spr_xo, ry - spr_yo);
	}
}
