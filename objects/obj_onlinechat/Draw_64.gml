if !isOpen
	exit;

#region Draw Messages

draw_set_font(global.font_small);
draw_set_align(fa_left, fa_top);
draw_set_alpha(0.7);
draw_rectangle_color(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0, false);
draw_set_alpha(1);

var ys = SCREEN_HEIGHT - 24 - (16 * ds_list_size(textList));
for (var i = 0; i < ds_list_size(textList); i++)
{
	var txt = ds_list_find_value(textList, i);
	var color = c_white;
	if string_pos(txt, ":") != 0 color = c_yellow;
	draw_text_color(8, ys + (16 * i), txt, color, color, color, color, 1);
}

#endregion
#region Password Censoring

var text = inputText;
if string_starts_with(text, "/login") || string_starts_with(text, "/register")
{
	var arr = string_split(text, " ", true);
	if array_length(arr) > 2
		text = arr[0] + arr[1] + string_repeat("*", string_length(arr[2]));
}

#endregion
#region Drawing Input

if text != ""
	draw_text(8, SCREEN_HEIGHT - 24, "> " + text + (curBlink ? " " : "_"));	
else
	draw_text_color(8, SCREEN_HEIGHT - 24, "> " + text + (curBlink ? " " : "_"), c_white, c_white, c_white, c_white, 0.5);	

#endregion
