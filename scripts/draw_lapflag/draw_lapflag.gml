function draw_lapflag(x, y, lapflag_index, sugary = false)
{
	if live_call(x, y, lapflag_index, sugary) return live_result;
	
	var posx = x - 72, posy = y - 18;
	
	var text_yo = 0;
	if !sugary
		text_yo = (-floor(lapflag_index) % 4) + 32;
	else
		text_yo = 30;
	
	draw_sprite(sugary ? spr_lapflag_ss : spr_lapflag, lapflag_index, posx, posy);
	draw_set_colour(c_white);
	draw_set_align(fa_center, fa_middle);
	draw_set_font(sugary ? global.lapfont_ss : global.lapfont);
	draw_text(posx + 34 - string_length(string(global.laps + 1)), posy + text_yo, string(global.laps + 1));
	draw_set_align(); // reset alignment
}
