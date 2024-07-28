var r = string_letters(room_get_name(room));
if string_pos("midway", r) or string_pos("treasure", r)
	exit;

var sugary = check_sugary();
if yi <= -36
	exit;

var msg = global.roommessage;
var yy = yi, xi = REMIX ? SCREEN_WIDTH / 2 : 500;

if msg == ""
	exit;

if (level && sugary) or room == tower_baby
{
	xi = 192;
	yy = SCREEN_HEIGHT - yy - 6;
}

draw_set_font(lang_get_font("smallfont"));
draw_set_align(fa_center, fa_middle);
draw_set_color(c_white);
draw_sprite(sugary ? spr_roomnamebg_ss : spr_roomnamebg, 0, xi, yy);
draw_text_ext(xi, yy + 8 - 3, msg, 12, 280);
