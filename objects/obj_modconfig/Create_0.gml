live_auto_call;

// prep
depth = -600;
image_speed = 0.35;
scr_init_input();
stickpressed = false;
con = 0;
t = 0;
buffer = 2;
sequence_layer = -1;
sequence = -1;
move_buffer = -1;
xo = 0;
yo = 0;
alpha = 1;
scroll = 0;
control_mouse = false;
state = 0;
state_trans = 0;
section_scroll = [0, 0];
menu_xo = 0;

#region preview window

reset_simuplayer = function()
{
	particles = [
	
	];
	simuplayer = {
		x: 960 / 2.5 / 2, y: 540 / 2.5 / 1.5, state: states.normal, hsp: 0, vsp: 0, sprite: spr_player_idle, image: 0, xscale: 1, timer: 0, move: 0, changed: false, angle: 0
	}
};
draw_simuplayer = function()
{
	var p = simuplayer;
	if p.y < -50
	{
		draw_sprite(spr_peppinoicon, 0, p.x, 25);
		exit;
	}
	
	shader_reset();
	var width = 960 / 2.5;
	
	var xo = p.x - lengthdir_x(28, p.angle - 90);
	var yo = p.y;
	
	if xo < 50
		draw_sprite_ext(p.sprite, p.image, xo + width, yo, p.xscale, 1, p.angle, c_white, 1);
	if xo > width - 50
		draw_sprite_ext(p.sprite, p.image, xo - width, yo, p.xscale, 1, p.angle, c_white, 1);
	
	draw_sprite_ext(p.sprite, p.image, xo, yo, p.xscale, 1, p.angle, c_white, 1);
};
draw_particles = function()
{
	for(var i = 0; i < array_length(particles); i++)
	{
		var p = particles[i];
		if p.img >= sprite_get_number(p.sprite) - 1
		{
			array_delete(particles, i, 1);
			i--;
			continue;
		}
		p.img += p.imgspeed;
		draw_sprite(p.sprite, p.img, p.x, p.y);
	}
};
add_particle = function(sprite, imgspeed, x, y)
{
	array_push(particles, {sprite: sprite, imgspeed: imgspeed, img: 0, x: x, y: y});
};
reset_simuplayer();

refresh_sequence = function()
{
	if layer_exists(sequence_layer)
		layer_destroy(sequence_layer);
	
	var section = sections_array[sel];
	if section.sel < 0
		exit;
	
	var opt = section.options_array[section.sel];
	if !is_callable(opt.drawfunc)
	{
		sequence_layer = layer_create(-1, "sequence_layer");
		if is_array(opt.drawfunc)
			sequence = layer_sequence_create(sequence_layer, 0, 0, opt.drawfunc[opt.value]);
		else if sequence_exists(opt.drawfunc)
			sequence = layer_sequence_create(sequence_layer, 0, 0, opt.drawfunc);
			
		layer_script_begin(sequence_layer, function()
		{
			if event_type == ev_draw && event_number == ev_draw_normal
			{
				if !surface_exists(global.modsurf)
					global.modsurf = surface_create(384, 216);
				
				surface_set_target(global.modsurf);
				draw_clear_alpha(c_black, 0);
				
				if object_index != obj_levelsettings
					toggle_alphafix(true);
			}
		});
		layer_script_end(sequence_layer, function()
		{
			if event_type == ev_draw && event_number == ev_draw_normal
			{
				// white border
				draw_set_colour(c_white);
				draw_roundrect(0, 0, 384 - 2, 216 - 2, true);
				
				surface_reset_target();
			}
		});
	}
};

#endregion
#region ModSection

sections_array = [];
function ModSection(name) constructor
{
	super = obj_modconfig;
	array_push(super.sections_array, self);
	
	simuplayer = super.simuplayer;
	refresh_sequence = super.refresh_sequence;
	add_particle = super.add_particle;
	draw_particles = super.draw_particles;
	draw_simuplayer = super.draw_simuplayer;
	
	options_array = [];
	sel = -1;
	options_pos = [];
	self.name = name;
	
	select = function(_sel)
	{
		sel = _sel;
		if sel != -1
			sound_play(sfx_step);
		
		if struct_exists(self, "machsnd")
			sound_stop(machsnd, true);
		
		simuplayer.state = states.titlescreen;
		simuplayer.changed = true;
		simuplayer.angle = 0;
		
		refresh_sequence();
	}
	refresh_options = function()
	{
		var yy = 0;
		
		options_pos = [];
		for(var i = 0; i < array_length(options_array); i++)
		{
			var opt = options_array[i];
			switch opt.type
			{
				case modconfig.option:
					yy += 20;
				
					var value = variable_global_get(opt.vari);
					for(var j = 0; j < array_length(opt.opts); j++)
					{
						if opt.opts[j][1] == value
							opt.value = j;
					}
					break;
			
				case modconfig.slider:
					yy += 20;
				
					var value = variable_global_get(opt.vari);
					opt.value = (value - opt.range[0]) / (opt.range[1] - opt.range[0]);
					break;
			
				default:
					yy += 20;
					break;
		
				case modconfig.section:
					yy += 30;
					yy += 40;
					break;
			}
			options_pos[i] = yy;
		}
	}
	dispose = function()
	{
		
	}
	
	enum modconfig
	{
		option,
		section,
		button,
		modifier,
		slider
	}
	
	add_option = function(variable, drawfunc = noone)
	{
		var struct = {
			type: modconfig.option,
			value: 0,
			vari: variable,
			name: lstr("mod_title_" + variable),
			desc: lstr("mod_desc_" + variable),
			opts: [["off", false], ["on", true]],
			drawfunc: drawfunc,
			condition: noone
		}
		array_push(options_array, struct);
		return struct;
	}
	add_button = function(local, func = noone, drawfunc = noone)
	{
		var struct = {
			type: modconfig.button,
			name: lstr("mod_title_" + local),
			desc: lstr("mod_desc_" + local),
			func: func,
			drawfunc: drawfunc,
			condition: noone
		}
		array_push(options_array, struct);
		return struct;
	}
	add_slider = function(variable, range = [0, 1], drawfunc = noone)
	{
		var struct = {
			type: modconfig.slider,
			value: 0,
			vari: variable,
			name: lstr("mod_title_" + variable),
			desc: lstr("mod_desc_" + variable),
			range: range,
			drawfunc: drawfunc,
			condition: noone
		}
		array_push(options_array, struct);
		return struct;
	}
	add_section = function(local)
	{
		var struct = {
			type: modconfig.section,
			name: lstr("mod_section_" + local)
		};
		array_push(options_array, struct);
		return struct;
	}
}

#endregion

sel = 0;
global.modsurf = noone;

// options
var add_online = function()
{
	with new ModSection("online")
	{
		var preview = function()
		{
			draw_text(16, 16, concat("WIP! OPACITY IS ", options_array[0].value));
		}
	
		add_slider("online_opacity", [0.1, 1], preview); // 0
	
		var opt = add_option("online_bubbles", preview); // 1
		opt.opts = [
			["off", bubble_style.off],
			["pto", bubble_style.pto],
			["ptt", bubble_style.ptt],
		];
	
		add_slider("online_volume", [0, 1], preview); // 2
	
		add_option("online_minichat", preview); // 3
	
		add_slider("online_name_opacity", [0, 1], preview); // 4
	
		add_option("online_name_smooth", preview); // 5
	
		refresh_options();
	}
}
if is_online
	add_online();

with new ModSection("gameplay")
{
	#region REMIX

	tv_bg = {surf: noone, sprite: spr_gate_entranceBG, parallax: [0.65, 0.75, 0.85], x: 0, y: 68};
	dispose = function()
	{
		delete tv_bg;
	}

	color1 = shader_get_uniform(shd_mach3effect, "color1");
	color2 = shader_get_uniform(shd_mach3effect, "color2");
	var opt = add_option("gameplay", function(val)
	{
		if val == 1
		{
			// move it
			var movespeed = -0.25;
		
			tv_bg.x += movespeed;
			if !surface_exists(tv_bg.surf)
				tv_bg.surf = surface_create(278, 268);
			
			// draw it
			surface_set_target(tv_bg.surf);
			
			for(var i = 0; i < sprite_get_number(tv_bg.sprite); i++)
				draw_sprite_tiled(tv_bg.sprite, i, 278 / 2 + tv_bg.x * max(lerp(-1, 1, tv_bg.parallax[i]), 0), 268);
		
			gpu_set_blendmode(bm_subtract);
			draw_sprite(spr_tv_clip, 1, 278 / 2, 268 - tv_bg.y);
			gpu_set_blendmode(bm_normal);
			
			surface_reset_target();
		
			draw_surface_ext(tv_bg.surf, 110 - 278 / 2, 70 - 268 + tv_bg.y, 1, 1, 0, c_white, 1);
			shader_reset();
		}
		else
			draw_sprite_ext(spr_tv_bgfinal, 1, 110, 70, 1, 1, 0, c_white, 1);
	
		shader_set(global.Pal_Shader);
		pal_swap_set(spr_peppalette, 1, 0);
		draw_sprite_ext(val == 1 ? spr_tv_idle_NEW : spr_tv_idle, super.image_index, 110, 70, 1, 1, 0, c_white, 1);
		shader_reset();
	
		if val == 1
		{
			shader_set(shd_mach3effect);
			gpu_set_blendmode(bm_normal);
		
			var b = global.mach_color1;
			shader_set_uniform_f(color1, color_get_red(b) / 255, color_get_green(b) / 255, color_get_blue(b) / 255);
			b = merge_colour(b, c_black, 0.9);
			shader_set_uniform_f(color2, color_get_red(b) / 255, color_get_green(b) / 255, color_get_blue(b) / 255);
		
			draw_sprite(spr_player_mach, 0, 240, 150);
			draw_sprite(spr_player_mach, 2, 340, 150);
		
			b = global.mach_color2;
			shader_set_uniform_f(color1, color_get_red(b) / 255, color_get_green(b) / 255, color_get_blue(b) / 255);
			b = merge_colour(b, c_black, 0.9);
			shader_set_uniform_f(color2, color_get_red(b) / 255, color_get_green(b) / 255, color_get_blue(b) / 255);
		
			draw_sprite(spr_player_mach, 1, 290, 150);
			shader_reset();
		}
		else
		{
			var mach_color1 = make_colour_rgb(96, 208, 72);
			var mach_color2 = make_colour_rgb(248, 0, 0);
		
			draw_sprite_ext(spr_player_mach, 0, 240, 150, 1, 1, 0, mach_color1, 1);
			draw_sprite_ext(spr_player_mach, 2, 340, 150, 1, 1, 0, mach_color1, 1);
			draw_sprite_ext(spr_player_mach, 1, 290, 150, 1, 1, 0, mach_color2, 1);
		}
	});

	#endregion
	#region GAMEPLAY
	
	/*
	var opt = add_option("iteration", function(val)
	{
		if val == IT.FINAL
			draw_sprite_ext(spr_player_longjumpend, super.image_index, 384 / 2, 216 / 2, 1, 1, 0, c_white, 1);
		if val == IT.APRIL
			draw_sprite_ext(spr_player_mach2jump, super.image_index, 384 / 2, 216 / 2, 1, 1, 0, c_white, 1);
		if val == IT.BNF
			draw_sprite_ext(spr_player_suplexgrabjump, super.image_index, 384 / 2 - 15, 216 / 2, 1, 1, 0, c_white, 1);
	});
	opt.opts = [
		//["old", IT.BNF],
		["april", IT.APRIL],
		["final", IT.FINAL],
	]
	*/

	#endregion
	#region EXPERIMENTAL

	add_option("experimental", function(val)
	{
		draw_set_colour(0);
		draw_rectangle(0, 0, 384, 216, false);
		draw_sprite_ext(spr_experimental, 0, 0, 0, 1, 1, 0, c_white, val ? 1 : 0.35);
	
		draw_set_colour(c_white);
		if !val
		{
			draw_set_font(lang_get_font("font_small"));
			draw_set_align(fa_center, fa_middle);
			draw_text(384 / 2, 216 / 1.2, lstr("mod_experimental")); // Experimental's off!
			draw_set_align();
		}
	});

	#endregion
	#region ATTACK STYLE

	var opt = add_option("attackstyle", [seq_attackstyle_grab, seq_attackstyle_kungfu, seq_attackstyle_shoulderbash, seq_attackstyle_lunge]);
	opt.opts = [
		["grab", 0],
		["kungfu", 1],
		["shoulderbash", 2],
		["lunge", 3],
	];

	#endregion
	#region SHOOT STYLE

	var opt = add_option("shootstyle", function(val)
	{
		static bullets = 3;
	
		var p = simuplayer;
		if p.state == states.titlescreen
		{
			p.xscale = 1;
			p.state = states.normal;
			p.sprite = spr_player_idle;
			p.move = 0;
			p.hsp = 0;
			bullets = 3;
			p.timer = 0;
		}
		else if p.x != 100 && p.state != states.punch
			p.x = Approach(p.x, 100, 10);
		else
		{
			if p.changed
			{
				p.changed = false;
				p.state = states.titlescreen;
			}
		
			p.timer++;
			if p.timer > 20
			{
				p.timer = 0;
				if val == 1 && floor(bullets) > 0 && frac(bullets) == 0
				{
					sound_play_centered(sfx_pistolshot);
					p.state = states.pistol;
					p.sprite = spr_player_pistolshot;
					p.image = 0;
					bullets--;
				}
				if val == 2
				{
					p.hsp = p.xscale * 6;
					p.timer = -50;
					sound_play_centered(sfx_breakdance);
					p.state = states.punch;
					p.sprite = spr_player_breakdancestart;
					p.image = 0;
				}
			}
		
			if val == 1 && p.state != states.pistol
			{
				if bullets == 0
					p.timer = -80;
				bullets = Approach(bullets, 3, 0.05);
			}
		}
		
		draw_simuplayer();
		
		if val == 1
		{
			for(var i = 0; i < floor(bullets); i++)
				draw_sprite(spr_peppinobullet_collectible, super.image_index, 136 - 46 * i, -32);
		}
	});
	opt.opts = [
		["none", 0],
		["pistol", 1],
		["breakdance", 2]
	];

	#endregion
	#region DOUBLE GRAB

	var opt = add_option("doublegrab", function(val)
	{
		static bullets = 3;
		var p = simuplayer;
	
		if p.sprite == spr_player_breakdanceuppercut && p.state == states.titlescreen
		{
			p.state = states.panicjump;
			p.move = 0;
			p.timer = -100;
		}
		else if p.changed
		{
			bullets = 3;
			if p.state == states.titlescreen
				p.state = states.normal;
			if p.state == states.normal
			{
				if p.x > 75 && p.x + p.hsp > 75
					p.move = -1;
				else if p.x <= 75 && p.x + p.hsp <= 75
					p.move = 1;
				else
				{
					p.x = 75;
					p.hsp = 0;
					p.move = 0;
					p.xscale = 1;
					p.timer = 10;
					p.changed = false;
				}
			}
		}
		else
		{
			if p.state == states.titlescreen
			{
				p.state = states.normal;
				p.sprite = spr_player_idle;
				p.x = 75;
				p.xscale = 1;
			}
		
			p.timer++;
			if p.timer >= 30 && val != 0 && (val != 3 or floor(bullets) > 0)
			{
				if p.state == states.handstandjump
				{
					p.timer = -30;
					if val == 1
					{
						sound_play_centered(sfx_dive);
						p.sprite = spr_player_attackdash;
						p.image = 0;
					}
					if val == 2
					{
						p.sprite = spr_player_faceplant;
						p.state = states.faceplant;
						p.hsp = 8;
						p.image = 0;
					}
					if val == 3
					{
						p.sprite = spr_player_chainsawdash;
						p.state = states.chainsawbump;
						p.hsp = 11;
						p.image = 0;
						bullets--;
					}
				}
				else
				{
					p.timer = 10;
					//sound_play_centered(sfx_suplexdash);
				
					p.state = states.handstandjump;
					p.sprite = spr_player_suplexdash;
					p.image = 0;
					p.move = p.xscale;
					p.hsp = 4 * p.move;
				}
			}
		}
	
		if val == 3
		{
			for(var i = 0; i < floor(bullets); i++)
				draw_sprite(spr_fuelHUD, super.image_index, 136 - 46 * i, 46);
		}
	
		draw_simuplayer();
	});
	opt.opts = [
		["none", 0],
		["chainsaw", 3],
		["shoulderbash", 1],
		["faceplant", 2]
	];

	#endregion
	#region BUFFED UPPERCUT

	var opt = add_option("uppercut", function(val)
	{
		var p = simuplayer;
		if p.state == states.titlescreen
		{
			p.timer = 0;
			p.state = states.normal;
		}
		p.move = 1;
	
		p.timer++;
		if p.timer >= 20
		{
			p.timer = -50;
			seq_afterimages_uppersnd();
		
			p.state = states.panicjump;
			p.sprite = spr_player_breakdanceuppercut;
			if val != 1
				p.hsp = 2;
			p.vsp = -12;
			p.image = 0;
		}
	
		draw_simuplayer();
	});

	#endregion
	#region HITSTUN

	var opt = add_option("hitstun", [seq_hitstun_off, seq_hitstun_early, seq_hitstun_on]);
	opt.opts = [
		["off", 0],
		["old", 2],
		["on", 1]
	];

	#endregion
	#region POUND JUMP

	var opt = add_option("poundjump", [seq_groundpoundjump_off, seq_groundpoundjump_on]);

	#endregion
	#region VIGI SUPERJUMP

	/*
	var opt = add_option("vigisuperjump", [seq_vigisuperjump_off, seq_vigisuperjump_dynamite, seq_vigisuperjump_on]);
	opt.opts = [
		["none", 0],
		["dynamite", 1],
		["mach3", 2]
	];
	*/

	#endregion
	#region HEAT METER

	var opt = add_option("heatmeter", function(val)
	{
		var xx = 960 / 2.5 / 2, yy = 540 / 2.5 / 2;
	
		if val
		{
			draw_sprite(spr_heatmeter, 0, xx, yy);
			draw_sprite(spr_pizzascore, 0, xx, yy);
		}
		else
			draw_sprite(spr_pizzascore, 0, xx, yy);
	});

	#endregion
	#region LAPPING

	lap = 2;
	lapshake = 0;

	var opt = add_button("lapping", function()
	{
		super.visible = false;
		with obj_option
		{
			backbuffer = 2;
			menu_goto(MENUS.lapping);
		}
	},
	function()
	{
		lapshake = Approach(lapshake, 0, 0.35);
		if lap < 999
		{
			if ++simuplayer.timer >= 30
			{
				simuplayer.timer = 0;
				lap++;
				lapshake = 3;
			}
		}
	
		var xx = 960 / 2.5 / 2, yy = 540 / 2.5 / 2;
		yy -= 152 / 2;
	
		draw_sprite(spr_lap2, 1, xx, yy);
	
		var lap_text = string(lap);
		var wd = sprite_get_width(spr_lapfontbig) * string_length(lap_text);
	
		shader_reset();
	
		// numbers!
		gpu_set_alphatestenable(true);
	
		for(var i = 1; i <= string_length(lap_text); i++)
		{
			var lx = xx - 8 + 39 * i - ((wd - 64) / 3) + random_range(-lapshake, lapshake);
			var ly = yy + 8 + random_range(-lapshake, lapshake);
			var letter = ord(string_char_at(lap_text, i)) - ord("0");
		
			gpu_set_blendmode_ext(bm_dest_color, bm_zero);
			draw_set_flash(#88A8C8);
			draw_sprite(spr_lapfontbig, letter, lx, ly + 3);
			draw_reset_flash();
			
			gpu_set_blendmode(bm_normal);
			draw_sprite(spr_lapfontbig, letter, lx, ly);
		}
	
		// the thingy
		gpu_set_blendmode(bm_normal);
		draw_sprite(spr_lap2, 2, xx - ((wd - 64) / 3), yy);
		gpu_set_blendmode_ext(bm_dest_color, bm_zero);
		draw_sprite(spr_lap2, 3, xx - ((wd - 64) / 3), yy);
		gpu_set_blendmode(bm_normal);
	
		gpu_set_alphatestenable(false);
	});
	opt.condition = function()
	{
		return [!global.lap, lstr("mod_condition_lapping")]; // Can't change this while lapping.
	}

	#endregion
	#region HOLIDAY OVERRIDE

	var opt = add_option("holidayoverride", function(val)
	{
		var xx = 960 / 2.5 / 2, yy = 540 / 2.5 / 2;
		if val == -1
			val = global.holiday;
	
		switch val
		{
			case holiday.none:
				draw_sprite(spr_PTG, super.image_index, xx + Wave(-3, 3, 2, 0), yy + 50);
				break;
			case holiday.halloween:
				draw_sprite(spr_PTGhalloween, super.image_index, xx + random_range(-2, 2), yy + 75 + random_range(-1, 1) - abs(sin(current_time / 1) * 50));
				break;
		}
	});
	opt.opts = [
		["off", -1],
		["none", holiday.none],
		["halloween", holiday.halloween]
	]
	opt.condition = function()
	{
		return [room == Mainmenu, lstr("mod_condition_holidayoverride")]; // Go back to the main menu to change this!
	}

	#endregion
	
	refresh_options();
}

/*
repeat 20
with new ModSection("filler")
{
	repeat 50
		add_button("gameplay");
	
	refresh_options();
}
*/

with new ModSection("input")
{
	#region SWAP GRAB

	add_option("swapgrab", function(val)
	{
		var cx = 80, cy = 50;
		draw_sprite(spr_tutorialkey, 0, cx, cy);
		draw_set_align(1, 1);
		draw_set_font(lang_get_font("tutorialfont"));
		draw_text_color_new(cx + 16, cy + 14, chr(global.key_slap), c_black, c_black, c_black, c_black, 1);
		draw_set_align();
	
		var cx = 260, cy = 50;
		draw_sprite(spr_tutorialkey, 0, cx, cy);
		draw_set_align(1, 1);
		draw_text_color_new(cx + 16, cy + 14, chr(global.key_chainsaw), c_black, c_black, c_black, c_black, 1);
		draw_set_align();
	
		shader_set(global.Pal_Shader);
		pal_swap_set(spr_peppalette, 1, false);
		draw_sprite(val ? spr_player_suplexdash : spr_player_kungfu1, 6, 100, 130);
		draw_sprite(val ? spr_player_kungfu1 : spr_player_suplexdash, 6, 280, 130);
		pal_swap_reset();
	});

	#endregion
	#region SHOOT BUTTON

	var opt = add_option("shootbutton", function(val)
	{
		shader_set(global.Pal_Shader);
		pal_swap_set(spr_peppalette, 1, false);
	
		draw_set_font(lang_get_font("tutorialfont"));
		if val == 0
		{
			var cx = 180, cy = 50;
			draw_sprite(spr_tutorialkey, 0, cx, cy);
			draw_set_align(1, 1);
			draw_text_color_new(cx + 16, cy + 14, chr(global.key_slap), c_black, c_black, c_black, c_black, 1);
			draw_set_align();
	
			draw_sprite(spr_player_shotgun, 0, 200, 130);
		}
		else if val == 1
		{
			var cx = 80, cy = 50;
			draw_sprite(spr_tutorialkey, 0, cx, cy);
			draw_set_align(1, 1);
			draw_text_color_new(cx + 16, cy + 14, chr(global.key_slap), c_black, c_black, c_black, c_black, 1);
			draw_set_align();
	
			draw_sprite(spr_player_suplexdash, 5, 100, 130);
		
			var cx = 260, cy = 50;
			draw_sprite(spr_tutorialkey, 0, cx, cy);
			draw_set_align(1, 1);
			draw_text_color_new(cx + 16, cy + 14, chr(global.key_shoot), c_black, c_black, c_black, c_black, 1);
			draw_set_align();
		
			draw_sprite(spr_player_shotgun, 0, 260, 130);
		}
		else if val == 2
		{
			var cx = 80, cy = 50;
			draw_sprite(spr_tutorialkey, 0, cx, cy);
			draw_set_align(1, 1);
			draw_text_color_new(cx + 16, cy + 14, chr(global.key_shoot), c_black, c_black, c_black, c_black, 1);
			draw_set_align();
		
			draw_sprite(spr_player_shotgun, 0, 100, 130);
		
			var cx = 260, cy = 50;
			draw_sprite(spr_tutorialkey, 0, cx, cy);
			draw_set_align(1, 1);
			draw_text_color_new(cx + 16, cy + 14, chr(global.key_slap), c_black, c_black, c_black, c_black, 1);
			draw_set_align();
		
			draw_sprite(spr_player_pistolshot, 1, 280, 130);
		}
	
		shader_reset();
	});
	opt.opts = [
		["off", false],
		["on", true],
		["shotgunonly", 2]
	]

	#endregion
	#region INPUT DISPLAY

	add_button("inputdisplay", function()
	{
		super.visible = false;
		with obj_option
			menu_goto(MENUS.inputdisplay);
	},
	function()
	{
		var xx = 960 / 2.5 / 2, yy = 540 / 2.5 / 2;
		with obj_inputdisplay
		{
			scr_init_input();
			draw_inputdisplay(xx - maxx / 2, yy - maxy / 2);
		}
	});

	#endregion
	
	refresh_options();
}

with new ModSection("visual")
{
	#region AFTERIMAGES

	var opt = add_option("afterimage", [seq_afterimages_final, seq_afterimages_eggplant]);
	opt.opts = [
		["final", 0],
		["eggplant", 1]
	]

	#endregion
	#region PANIC BG

	if !global.performance
	{
		var opt = add_option("panicbg", function(val)
		{
			if val
			{
				shader_set(shd_panicbg);
		
				shader_set_uniform_f(shader_get_uniform(shd_panicbg, "panic"), 1);
				shader_set_uniform_f(shader_get_uniform(shd_panicbg, "time"), current_time / 1000);
		
				draw_sprite_tiled_ext(bg_desertescape, super.image_index, 0, 0, 0.4, 0.4, c_white, 1);
		
				shader_reset();
			}
			else
				draw_sprite_ext(bg_desertescape, super.image_index, 0, 0, 0.4, 0.4, 0, c_white, 1);
		});
		opt.opts = [
			["off", false],
			["on", true],
			["onblur", 2]
		]
	}

	#endregion
	#region SLOPE ROTATION

	var opt = add_option("sloperot", function(val)
	{
		var slopex = 132;
		draw_sprite_ext(spr_slope, 0, slopex, 94 + 32, 2, 2, 0, c_white, 1);
		draw_sprite_ext(spr_slope, 0, slopex + 32 * 4, 94 + 32, -2, 2, 0, c_white, 1);
	
		var p = simuplayer;
		if p.state == states.titlescreen
		{
			p.x = 50;
			p.state = states.actor;
			p.vsp = 0;
			p.sprite = spr_player_move;
			p.xscale = 1;
		}
	
		p.image += p.hsp / 10;
		if p.x > slopex + 32 * 4
		{
			p.angle = lerp(p.angle, 0, 0.5);
			p.y = 144;
			p.hsp = Approach(p.hsp, 5, 0.2);
		}
		else if p.x > slopex + 32 * 2
		{
			var slop = slopex + 32 * 2;
		
			p.angle = lerp(p.angle, -35, 0.3);
			p.y = lerp(144, 144 - 64, 1 - clamp((p.x - slop) / (32 * 2), 0, 1));
			p.hsp = 3;
		}
		else if p.x > slopex
		{
			p.angle = lerp(p.angle, 35, 0.5);
			p.y = lerp(144, 144 - 64, clamp((p.x - slopex) / (32 * 2), 0, 1));
			p.hsp = 3;
		}
		else
		{
			p.angle = lerp(p.angle, 0, 0.5);
			p.y = 144;
			p.hsp = 5;
		}
		if val == 0
			p.angle = 0;
	
		draw_simuplayer();
	});

	#endregion
	#region ENEMY SPIN

	var opt = add_option("enemyrot", function(val)
	{
		var xx = 960 / 2.5 / 2, yy = 540 / 2.5 / 2;
	
		if ++simuplayer.timer >= 10
		{
			simuplayer.timer = 0;
			add_particle(spr_cloudeffect, 0.5, xx + random_range(-50, 50), yy + random_range(-50, 50));
		}
	
		draw_sprite_ext(spr_slimedead, 0, xx, yy, 1, 1, -current_time / 2 * val, c_white, 1);
		draw_particles();
	});

	#endregion
	#region SHOW FPS

	showfps = 60;
	showfps_t = 60;

	var opt = add_option("showfps", function(val)
	{
		if showfps_t > 0
			showfps_t--;
		else
		{
			showfps = irandom_range(10, 60);
			showfps_t = 60;
		}
	
		simuplayer.image += 0.35 * (showfps / 60);
		simuplayer.state = states.actor;
	
		if val
		{
			draw_set_font(lang_get_font("font_small"));
			draw_set_colour(showfps < 30 ? (showfps < 15 ? c_red : c_yellow) : c_white);
			draw_set_align(fa_right);
			draw_text_transformed(960 / 2.5 - 20, 540 / 2.5 - 50, string(showfps), 2, 2, 0);
			draw_set_align();
		}
	
		shader_set(global.Pal_Shader);
		pal_swap_set(spr_peppalette, 1, false);
		draw_sprite_ext(spr_player_move, simuplayer.image, 960 / 2.5 / 4, 100, 2, 2, 0, c_white, 1);
		pal_swap_reset();
	});

	#endregion
	#region COLORBLIND

	/*
	var opt = add_option("Colorblind Mode", "colorblind_type", "Applies a fullscreen shader that hopefully helps colorblindness.", function(val)
	{
		global.colorblind_type = val;
		draw_sprite_ext(spr_mirrored_level, 0, -258, -292, 0.9, 0.9, 0, c_white, 1);
	});
	opt.opts = [
		["NONE", -1],
		["PROTANOPIA", 0],
		["DEUTERANOPIA", 1],
		["TRITANOPIA", 2]
	]
	*/

	#endregion
	#region SECRET STYLE

	var opt = add_option("secrettiles", function(val)
	{
		static distance = 0;
		static alpha = 0;
	
		var p = simuplayer;
		if p.state == states.titlescreen
		{
			p.state = states.normal;
			p.timer = 0;
		}
		if ++p.timer >= 200
			p.timer = 0;
	
		distance = lerp(distance, (p.timer < 120) * 100, 0.15);
		alpha = Approach(alpha, (p.timer < 120) ? 0 : 1, 0.1);
	
		draw_sprite(spr_secretwall, val, -200, -100);
	
		shader_set(shd_secrettile);
		var u_bounds = shader_get_uniform(shd_secrettile, "u_secret_tile_bounds");
		var u_alpha = shader_get_uniform(shd_secrettile, "u_secret_tile_alpha");
		var u_remix = shader_get_uniform(shd_secrettile, "u_remix_flag");
		var u_alphafix = shader_get_uniform(shd_secrettile, "u_alphafix");
	
		shader_set_uniform_f(u_bounds, 373 - 200, 0, 960 / 2.5, 540 / 2.5);
		shader_set_uniform_f(u_alpha, 1 - alpha);
		shader_set_uniform_f(u_remix, val == 1);
		shader_set_uniform_f(u_alphafix, 1);
	
		if val == 1
		{
			var clip_distance = shader_get_uniform(shd_secrettile, "u_secret_tile_clip_distance");
			var clip_position = shader_get_uniform(shd_secrettile, "u_secret_tile_clip_position");
			var fade_size = shader_get_uniform(shd_secrettile, "u_secret_tile_fade_size");
			var fade_intensity = shader_get_uniform(shd_secrettile, "u_secret_tile_fade_intensity");

			shader_set_uniform_f(clip_distance, distance);
			shader_set_uniform_f(clip_position, Wave(960 / 5, 960 / 5 + 100, 2, 0), 540 / 5);
			shader_set_uniform_f(fade_size, global.secrettile_fade_size);
			shader_set_uniform_f(fade_intensity, global.secrettile_fade_intensity);
		}
		draw_sprite(spr_secretwall, !val, -200, -100);
		shader_reset();
	});
	opt.opts = [
		["normal", 0],
		["spotlight", 1]
	]

	#endregion
	#region SMOOTH CAM

	smoothcamx = 960 / 5;
	add_slider("smoothcam", [0, 0.75], function(val)
	{
		var p = simuplayer;
		if p.state == states.titlescreen
		{
			p.state = states.normal;
			p.sprite = spr_player_idle;
			p.x = 960 / 5;
			p.xscale = 1;
		}
	
		if ((p.xscale == 1 && p.x < 960 / 5 + 120)
		or (p.xscale == -1 && p.x > 960 / 5 - 120))
		&& p.timer == 0
		{
			p.move = p.xscale;
			p.timer = 0;
		}
		else
		{
			if p.timer == 0
			{
				p.move = 0;
				p.xscale *= -1;
			}
			p.timer++;
		
			if p.timer >= 50
				p.timer = 0;
		}
	
		smoothcamx = lerp(p.x, smoothcamx, val * 1.2);
		draw_set_colour(c_white);
		draw_set_alpha(1);
		//draw_rectangle(smoothcamx - 960 / 10, p.y - 540 / 10, smoothcamx + 960 / 10, p.y + 540 / 10, true);
	
		draw_sprite_ext(spr_micnoise2, super.image_index, smoothcamx, p.y + Wave(-90, -80, 1, 0), p.xscale, 1, 0, c_white, 1);
	
		draw_simuplayer();
	});

	#endregion
	#region HUD

	var opt = add_option("hud", function(val)
	{
		if val == 0
		{
			draw_sprite_ext(spr_tv_bgfinal, 1, 960 / 5, 540 / 5, 1, 1, 0, c_white, 1);
			draw_sprite(spr_tv_idle, super.image_index, 960 / 5, 540 / 5);
		}
		if val == 1
		{
			draw_sprite(spr_pepinoHUD, super.image_index, 960 / 5, 540 / 5 - 8);
			draw_sprite(spr_speedbar, 0, 960 / 5, 540 / 5 + 32);
		}
	});
	opt.opts = [
		["old", 1],
		["april", 2],
		["final", 0],
	]

	#endregion
	#region BLOCKS

	var opt = add_option("blockstyle", function(val)
	{
		if val == 0
		{
			draw_sprite(spr_towerblock, 0, 960 / 5 - 32 - 80, 540 / 5 - 32);
			draw_sprite(spr_towerblocksmall, 0, 960 / 5 - 16, 540 / 5 - 16);
			draw_sprite(spr_metaltowerblock, 0, 960 / 5 - 32 + 80, 540 / 5 - 32);
		}
		if val == 1
		{
			draw_sprite(spr_bigdestroy, super.image_index, 960 / 5 - 32 - 80, 540 / 5 - 32);
			draw_sprite(spr_destroyable, super.image_index, 960 / 5 - 16, 540 / 5 - 16);
			draw_sprite(spr_metalb, super.image_index, 960 / 5 - 32 + 80, 540 / 5 - 32);
		}
		if val == 2
		{
			draw_sprite(spr_bigdestroy_old, 0, 960 / 5 - 32 - 80, 540 / 5 - 32);
			draw_sprite(spr_destroyable_old, 0, 960 / 5 - 16, 540 / 5 - 16);
			draw_sprite(spr_metaltowerblock, 0, 960 / 5 - 32 + 80, 540 / 5 - 32);
		}
	});
	opt.opts = [
		["old", 2],
		["final", 0],
		["september", 1]
	]

	#endregion
	#region ROOM NAMES

	rname_y = -50;
	var opt = add_option("roomnames", function(val)
	{
		if val
			rname_y = Approach(rname_y, 32, 5);
		else
			rname_y = Approach(rname_y, -50, 1);
	
		var xi = 384 / 2, yy = rname_y;
		draw_sprite_tiled(bg_secret, super.image_index, current_time / 100, current_time / 100);
		draw_sprite(spr_roomnamebg, 0, xi, yy);
	
		draw_set_font(lang_get_font("smallfont"));
		draw_set_align(fa_center, fa_middle);
		draw_set_color(c_white);
		draw_text_ext(xi, yy + 8 - 3, lstr("mod_ballsack"), 12, 280); // BALLSACK CITY
		draw_set_align();
	});

	#endregion
	#region SUGARY OVERRIDES

	var opt = add_option("sugaryoverride", function(val)
	{
		var wd = 960 / 2.5, ht = 540 / 2.5;
	
		/*
		var seconds = (60 * 10) - ((current_time / 1000) % (60 * 10));
		var minutes = floor(seconds / 60);
		seconds = floor(seconds % 60);
		*/
	
		if val
		{
			draw_sprite(spr_escapecollect_ss, super.image_index, 80, 50);
			draw_sprite(spr_escapecollectbig_ss, super.image_index, 250, 50 - 16);
		
			draw_sprite(spr_bartimer_normalBack, super.image_index, wd / 2, ht - 50);
			draw_sprite(spr_bartimer_normalFront, super.image_index, wd / 2, ht - 50);
		
			/*
			draw_set_align(1, 1);
			draw_set_font(lang_get_font("sugarypromptfont"));
			draw_text(wd / 2 - 11, ht - 50 - 20, concat(minutes, ":", seconds < 10 ? "0" : "", seconds));
			*/
		}
		else
		{
			draw_sprite(spr_escapecollect, super.image_index, 80, 50);
			draw_sprite(spr_escapecollectbig, super.image_index, 250, 50 - 16);
		
			var _barpos = 100;
		
			var timer_x = wd / 2 - sprite_get_width(spr_timer_bar) / 2 - 30, timer_y = ht - 70;
		
			var clip_x = timer_x + 3;
			var clip_y = timer_y + 5;
		
			draw_set_bounds(clip_x, clip_y, clip_x + _barpos, clip_y + 30, true);
			draw_sprite_tiled(spr_timer_barfill, 0, clip_x + -current_time / 200, clip_y);
			draw_reset_clip();
		
			draw_sprite(spr_timer_bar, super.image_index, timer_x, timer_y);
			draw_sprite(spr_timer_johnface, super.image_index, timer_x + 13 + _barpos, timer_y + 20);
			draw_sprite(spr_timer_pizzaface1, super.image_index, timer_x + 320, timer_y + 10);
		}
	});

	#endregion
	#region PERFORMANCE

	/*
	var opt = add_option("performance", function(val)
	{
	
	});
	*/

	#endregion
	
	refresh_options();
}

with new ModSection("misc")
{
	#region MACH SOUND

	machsnd = sound_create_instance(sfx_mach);
	dispose = function()
	{
		destroy_sounds([machsnd]);
	}
	
	var opt = add_option("machsnd", function(val)
	{
		var p = simuplayer;
		if p.state == states.titlescreen
		{
			p.state = states.actor;
			p.timer = 0;
			p.sprite = spr_player_idle;
			p.x = 384 / 2;
			p.hsp = 0;
		}
	
		++p.timer;
		p.image += 0.35;
	
		if !sound_is_playing(machsnd)
			sound_play(machsnd);
	
		sound_instance_move(machsnd, camera_get_view_x(view_camera[0]) + 960 / 2, camera_get_view_y(view_camera[0]) + 540 / 2);
		switch p.sprite
		{
			case spr_player_idle:
				fmod_event_instance_set_parameter(machsnd, "state", 0, true);
				if p.timer >= 30
				{
					p.sprite = spr_player_mach1;
					p.image = 0;
				}
				break;
		
			case spr_player_mach1:
				fmod_event_instance_set_parameter(machsnd, "state", val ? 5 : 1, true);
			
				p.timer = 0;
				if p.image >= sprite_get_number(p.sprite) - 1
					p.sprite = spr_player_mach;
				break;
		
			case spr_player_mach:
				fmod_event_instance_set_parameter(machsnd, "state", val ? 6 : 2, true);
			
				p.image += 0.2;
				if p.timer >= 40
				{
					p.sprite = spr_player_mach4;
					p.timer = 0;
				}
				break;
		
			case spr_player_mach4:
				fmod_event_instance_set_parameter(machsnd, "state", val ? 7 : 3, true);
			
				if p.timer >= 80
				{
					p.sprite = spr_player_machslidestart;
					p.timer = 0;
					p.image = 0;
				
					sound_play_centered(sfx_break);
				}
				break;
		
			case spr_player_machslidestart:
				fmod_event_instance_set_parameter(machsnd, "state", 0, true);
			
				if p.image >= sprite_get_number(p.sprite) - 1
				{
					p.sprite = spr_player_machslide;
					p.timer = 0;
				}
				break;
			case spr_player_machslide:
				if p.timer > 10
				{
					p.sprite = spr_player_machslideend;
					p.image = 0;
				}
				break;
			case spr_player_machslideend:
				if p.image >= sprite_get_number(p.sprite) - 1
				{
					p.sprite = spr_player_idle;
					p.timer = 0;
				}
				break;
		}
		/*
		if p.image >= sprite_get_number(p.sprite) - 1
		{
		
		}
		*/
		draw_simuplayer();
	});
	opt.opts = [
		["final", 0],
		["old", 1],
	]

	#endregion
	#region RICH PRESENCE

	var opt = add_option("richpresence", function(val)
	{
		var wd = 960 / 2.5;
		var ht = 540 / 2.5;
	
		draw_clear($E66054);
	
		if val
		{
			draw_set_font(font1);
			draw_set_align();
			draw_text(16, 16, "PLAYING A GAME");
	
			draw_sprite_ext(spr_checkerboard, 0, 16 + 2, 64 + 2, 3.5, 3.5, 0, c_black, 0.25);
			draw_sprite_ext(spr_checkerboard, 0, 16, 64, 3.5, 3.5, 0, #ad6fe5, 1);
			draw_sprite_ext(spr_title, 0, 24, 100, 0.25, 0.25, 0, c_white, 1);
	
			draw_set_font(lang_get_font("font_small"));
			draw_text(146, 100, "Pizza Tower Cheesed Up!\nMain Menu");
		}
		else
		{
			draw_set_font(font0);
			draw_set_align(fa_center);
			draw_text_transformed(wd / 2, ht / 2 - 20, lstr("mod_drpc2"), 2, 2, 0);
		}
	});

	#endregion
	
	refresh_options();
}

if !is_online
	add_online();
