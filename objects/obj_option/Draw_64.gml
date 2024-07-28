live_auto_call;

toggle_alphafix(true);
var sugary = check_sugary();

draw_rectangle_color(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0, false);
if sugary
	draw_sprite_tiled(bg_options_ss, 0, bg_x, bg_y);
else
{
	for (var i = 0; i < array_length(bg_alpha); i++)
		draw_sprite_tiled_ext(spr_optionsBG, i, bg_x, bg_y, 1, 1, c_white, bg_alpha[i]);
}
if room != Mainmenu
{
	with obj_keyconfig
		event_perform(ev_draw, ev_gui);
}
if instance_exists(obj_keyconfig) or instance_exists(obj_screenconfirm) or safe_get(obj_modconfig, "visible")
{
	tooltip_alpha = 0;
	exit;
}

draw_set_font(lang_get_font("bigfont"));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

var _os = optionselected;
var m = menus[menu];
var options = m.options;
var len = array_length(options);
var size = (string_height(lang_get_value("default_letter")) * len) + (len * m.ypad);
var xx = SCREEN_WIDTH / 2;
var yy = (SCREEN_HEIGHT / 2) - (size / 4);

var xpad = m.xpad;
if sugary
	xpad -= 32;

switch (m.anchor)
{
	case anchor.center:
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		var c = c_white;
		var a = 1;
		for (i = 0; i < len; i++)
		{
			var o = options[i];
			c = c_gray;
			if (i == _os)
				c = c_white;
			var t = lang_get_value(o.name);
			draw_text_color(xx, yy + (m.ypad * i), t, c, c, c, c, a);
			if (menu == MENUS.main && !sugary)
				scr_pauseicon_draw(i, xx + (string_width(t) / 2) + 50, yy + (m.ypad * i) + (string_height(t) / 2));
		}
		break;
	
	case anchor.left:
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		xx = xpad;
		c = c_white;
		a = 1;
		
		for (i = 0; i < len; i++)
		{
			draw_set_halign(fa_left);
			o = options[i];
			c = c_gray;
			if (i == _os)
				c = c_white;
			
			if o.type == menutype.press && !o.localization
                var txt = o.name;
            else
			{
                var txt = lang_get_value(o.name);
				if is_undefined(txt)
					txt = o.name;
			}
			if sugary && o.name == "option_back"
			{
				draw_set_align(fa_center);
				draw_text_color(150, yy - 50, txt, c, c, c, c, a);
			}
			else
				draw_text_color(xx, yy + (m.ypad * i), txt, c, c, c, c, a);
			
			draw_set_halign(fa_right);
			switch (o.type)
			{
				case menutype.toggle:
					draw_text_color(SCREEN_WIDTH - xpad, yy + (m.ypad * i), o.value ? lang_get_value("option_on") : lang_get_value("option_off"), c, c, c, c, a);
					break;
				
				case menutype.slide:
					var w = 200;
					var h = 5;
					var aw = w * (o.value / 100);
					var x1 = SCREEN_WIDTH - xpad - w;
					var y1 = yy + (m.ypad * i);
					var x2 = x1 + aw;
					var y2 = y1 + h;
					
					var spr = spr_slidericon;
					if menu != MENUS.audio
						spr = spr_slidericon2;
					
					draw_set_alpha(a);
					draw_sprite_ext(spr_slider, 0, x1, y1, 1, 1, 0, c_dkgray, a);
					draw_sprite_ext(spr_slider, 0, x1, y1, 1, 1, 0, c, a);
					draw_set_alpha(1);
					
					draw_sprite(spr, o.moving ? 1 : 0, x2, y2 - h);
					break;
				
				case menutype.multiple:
					var select = o.values[o.value];
					var n = select.name;
					if (select.localization)
						n = lang_get_value(select.name);
					draw_text_color(SCREEN_WIDTH - xpad, yy + (m.ypad * i), n, c, c, c, c, a);
					break;
			}
		}
		break;
}

var curr = options[_os];
if tooltip != curr.tooltip
{
	tooltip_alpha = Approach(tooltip_alpha, 0, curr.tooltip == "" ? 0.25 : 1);
	if tooltip_alpha == 0
		tooltip = curr.tooltip;
}
else if tooltip != ""
	tooltip_alpha = Approach(tooltip_alpha, 1, 0.25);

if tooltip_alpha > 0
{
	draw_set_font(lang_get_font("font_small"));
	draw_set_align(fa_center, fa_middle);
	
	var str = tooltip;
	var xx = SCREEN_WIDTH / 2, yy = SCREEN_HEIGHT * 0.86, wd = string_width(str) + 32, ht = string_height(str) + 16;
	
	draw_set_alpha(tooltip_alpha / 2);
	draw_set_colour(c_black);
	draw_roundrect(xx - wd / 2 - 1, yy - ht / 2 - 1, xx + wd / 2, yy + ht / 2 - 2, false);
	
	draw_set_alpha(tooltip_alpha);
	draw_set_colour(c_white);
	draw_text_colour(xx + 2, yy + 2, tooltip, 0, 0, 0, 0, tooltip_alpha * 0.35);
	draw_text(xx, yy, str);
	
	draw_set_align();
}

if (room != Mainmenu)
{
	with (obj_transfotip)
		event_perform(ev_draw, ev_gui);
}
