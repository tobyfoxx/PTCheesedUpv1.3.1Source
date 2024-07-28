live_auto_call;

// options left side
draw_set_colour(c_white);
draw_set_align();

toggle_alphafix(true);
reset_blendmode();
draw_set_alpha(alpha);

var yy = 60 - scroll;
//if array_last(options_pos) < SCREEN_HEIGHT / 3
//	yy = round(max((SCREEN_HEIGHT / 2) - array_last(options_pos) / 2, 70) - scroll);

var temp_sel = -1;
for(var i = 0, n = array_length(options_array); i < n; ++i)
{
	var opt = options_array[i], locked = false;
	if opt.type != modconfig.section && is_callable(opt.condition)
		locked = !opt.condition()[0];
	
	switch opt.type
	{
		default:
			draw_set_align();
			draw_set_font(lang_get_font("font_small"));
			
			if point_in_rectangle(mouse_x_gui, mouse_y_gui, 80, yy, 80 + 380, yy + 18)
			&& control_mouse
			{
				if self.sel != i
					select(i);
				temp_sel = i;
			}
			
			if sel == i
			{
				draw_set_colour(locked ? c_gray : c_white);
				draw_sprite_ext(spr_cursor, image_index, 2 + 40 + xo, 2 + yy + 8 + yo, 1, 1, 0, c_black, 0.25 * alpha);
				draw_sprite(spr_cursor, image_index, 40 + xo, yy + 8 + yo);
			}
			else
				draw_set_colour(locked ? c_gray : c_ltgray);
			
			draw_text_color(2 + 80, 2 + yy, opt.name, 0, 0, 0, 0, 0.25 * alpha);
			draw_text(80, yy, opt.name);
			
			// value
			var str = "";
			if opt.type == modconfig.slider
				str = string(floor(opt.value * 100)) + "%";
			if opt.type == modconfig.option or opt.type == modconfig.modifier
				str = lstr("mod_" + opt.opts[opt.value][0]);
			
			if str != ""
			{
				var scale = min(string_width(str), 100) / string_width(str);
				draw_set_align(fa_center);
				
				draw_text_transformed_color(2 + 350, 2 + yy, str, scale, 1, 0, 0, 0, 0, 0, 0.25 * alpha);
				draw_text_transformed(350, yy, str, scale, 1, 0);
				
				if sel == i && opt.type != modconfig.slider && !locked
				{
					if opt.value > 0
						draw_text(350 - string_width(str) * scale / 2 - Wave(16, 24, 2, 0), yy, "<");
					if opt.value < array_length(opt.opts) - 1
						draw_text(350 + string_width(str) * scale / 2 + Wave(16, 24, 2, 0), yy, ">");
				}
			}
			
			yy += 20;
			break;
		
		case modconfig.section: // SECTION
			draw_set_align();
			
			draw_set_colour(c_white);
			draw_set_font(lang_get_font("creditsfont"));
			
			if i != 0
				yy += 30;
			draw_text_color_new(2 + 60, 2 + yy, options_array[i].name, 0, 0, 0, 0, 0.25 * alpha);
			draw_text_new(60, yy, options_array[i].name);
			yy += 40;
			break;
	}
}

// current option
draw_set_colour(c_white);
if temp_sel == -1 && control_mouse && self.sel != -1
	select(-1);
if sel == -1
{
	toggle_alphafix(false);
	exit;
}

var opt = options_array[sel];
var right_x = SCREEN_WIDTH - 260;
draw_set_font(lang_get_font("bigfont"));
draw_set_align(fa_center);
draw_text_color_new(2 + right_x, 2 + 80, string_upper(opt.name), 0, 0, 0, 0, 0.25 * alpha);
draw_text_new(right_x, 80, string_upper(opt.name));

var drawer = 0;
if is_callable(opt.drawfunc)
	drawer = 1;
else if is_array(opt.drawfunc) or sequence_exists(opt.drawfunc)
	drawer = 2;

draw_set_font(lang_get_font("font_small"));
draw_text_ext_color(2 + right_x, 2 + 420, opt.desc, 18, 440, 0, 0, 0, 0, 0.25 * alpha);
draw_text_ext(right_x, 420, opt.desc, 18, 440);

if opt.type == modconfig.option or opt.type == modconfig.modifier
{
	draw_set_font(lang_get_font("smallfont"));
	if opt.value < array_length(opt.opts)
	{
		var str = lstr("mod_" + opt.opts[opt.value][0]);
		draw_text_color_new(2 + right_x, 2 + 116, str, 0, 0, 0, 0, 0.25 * alpha);
		draw_text_new(right_x, 116, str);
		
		/*
		draw_set_font(lang_get_font("font_small"));
		if opt.value > 0
			draw_text(700 - string_width(str) / 2 - Wave(20, 25, 2, 0), 116, "<");
		if opt.value < array_length(opt.opts) - 1
			draw_text(700 + string_width(str) / 2 + Wave(20, 25, 2, 0), 116, ">");
		*/
	}
}
if opt.type == modconfig.slider
{
	draw_sprite_ext(spr_slider, 0, right_x - 100, 116, 1, 1, 0, c_white, alpha);
	draw_sprite(spr_slidericon2, 0, right_x - 100 + 200 * opt.value, 116);
}

if drawer
{
	// roundrect background
	var xx = right_x, wd = 384;
	var yy = 260, ht = 216;
	
	draw_set_alpha(1);
	
	// DRAW IT
	var condition = [true];
	if opt.type != modconfig.section && is_callable(opt.condition)
		condition = opt.condition();
	
	if !condition[0]
	{
		if !surface_exists(global.modsurf)
			global.modsurf = surface_create(wd, ht);
		
		surface_set_target(global.modsurf);
		draw_clear_alpha(c_black, 0.5);
		
		draw_set_font(lang_get_font("font_small"));
		draw_set_align(fa_center, fa_middle);
		draw_text(960 / 2.5 / 2, 540 / 2.5 / 2, condition[1]);
		
		// white border
		draw_set_colour(c_white);
		draw_roundrect(0, 0, wd - 2, ht - 2, true);
			
		surface_reset_target();
	}
	else if is_callable(opt.drawfunc)
	{
		if !surface_exists(global.modsurf)
			global.modsurf = surface_create(wd, ht);
		
		surface_set_target(global.modsurf);
		draw_clear_alpha(c_black, 0);
		
		if opt.type == modconfig.option or opt.type == modconfig.modifier
			opt.drawfunc(opt.opts[opt.value][1]);
		else if opt.type == modconfig.slider
		{
			var value = (opt.range[0] + (opt.range[1] - opt.range[0]) * opt.value);
			opt.drawfunc(value);
		}
		else
			opt.drawfunc();
		
		// white border
		draw_set_colour(c_white);
		draw_roundrect(0, 0, wd - 2, ht - 2, true);
			
		surface_reset_target();
	}
	
	toggle_alphafix(true);
	
	if surface_exists(global.modsurf)
	{
		/* shadow */ draw_surface_ext(global.modsurf, 3 + xx - wd / 2, 3 + yy - ht / 2, 1, 1, 0, 0, 0.25 * alpha);
		draw_surface_ext(global.modsurf, xx - wd / 2, yy - ht / 2, 1, 1, 0, c_white, alpha);
	}
}
draw_set_alpha(1);