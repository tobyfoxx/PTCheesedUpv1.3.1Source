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
control_mouse = false;
scrolltarget = 0;

select = function(sel)
{
	self.sel = sel;
	
	if sel != -1
		sound_play(sfx_step);
	
	simuplayer.state = states.titlescreen;
	simuplayer.changed = true;
	simuplayer.angle = 0;
		
	refresh_sequence();
}

options_array = [];
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
add_section = function(local)
{
	var struct = {
		type: modconfig.section,
		name: lstr("mod_section_" + local)
	};
	array_push(options_array, struct);
	return struct;
}
sel = 1;
global.modsurf = noone;

// simuplayer
reset_simuplayer = function()
{
	particles = [
	
	];
	simuplayer = {
		x: 960 / 2.5 / 2, y: 540 / 2.5 / 1.5, state: states.normal, hsp: 0, vsp: 0, sprite: spr_player_idle, image: 0, xscale: 1, timer: 0, move: 0, changed: false, angle: 0
	}
}
function draw_simuplayer()
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
}
function draw_particles()
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
}
function add_particle(sprite, imgspeed, x, y)
{
	array_push(particles, {sprite: sprite, imgspeed: imgspeed, img: 0, x: x, y: y});
}
reset_simuplayer();

xo = 0;
yo = 0;
alpha = 1;
scroll = 0;

refresh_options = function()
{
	var yy = 0;
	
	options_pos = [];
	for(var i = 0; i < array_length(options_array); i++)
	{
		var opt = options_array[i];
		switch opt.type
		{
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
refresh_options();

refresh_sequence = function()
{
	if layer_exists(sequence_layer)
		layer_destroy(sequence_layer);
	if sel < 0
		exit;
	
	var opt = options_array[sel];
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
}
