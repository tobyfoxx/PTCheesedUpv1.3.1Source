live_auto_call;

if !init
	exit;

draw_set_align();
draw_set_colour(c_white);
shader_reset();
gpu_set_blendmode(bm_normal);

// animation
if anim_con == 0
{
	curve = animcurve_channel_evaluate(outback, anim_t);
	anim_t = Approach(anim_t, 1, 0.035);
}
if anim_con == 1 or anim_con == 2
{
	curve = animcurve_channel_evaluate(incubic, anim_t);
	anim_t = Approach(anim_t, 0, 0.06);
}

// background
var spotlight_size = (SCREEN_WIDTH / (960 / 560)) * curve;

bg_pos = (bg_pos + 0.5) % 64;
if curve < 1
	draw_set_spotlight(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, spotlight_size);
	
draw_set_alpha(0.75)
draw_set_color(merge_colour(make_color_rgb(121, 103, 151), c_green, mixingfade));
draw_rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, false);
draw_set_alpha(1);
draw_set_color(c_white);

if !global.performance
{
	if anim_t < 1 && !global.performance
	{
		var shader = shd_skinchoice_animation;
		shader_set(shader);
	
		// Circle Clip
		var origin_pos = shader_get_uniform(shader, "u_origin");
		var radius_pos = shader_get_uniform(shader, "u_radius");
		var alphafix_pos = shader_get_uniform(shader, "u_alphafix");
	
		shader_set_uniform_f(origin_pos, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
		shader_set_uniform_f(radius_pos, spotlight_size);
		shader_set_uniform_f(alphafix_pos, 0.0);
	
		// Now actual Animation stuff
		var texcoord_center_pos = shader_get_uniform(shader, "u_texcoord_center");
		var sprite_size_pos = shader_get_uniform(shader, "u_sprite_size");
		var curve_pos = shader_get_uniform(shader, "u_curve");
		var uvs = sprite_get_uvs(spr_skinmenupizza, bg_image);
		var tex_coord_width = uvs[2] - uvs[0];
		var tex_coord_height = uvs[3] - uvs[1];
	
		var tex_center_x = (uvs[0] + (tex_coord_width / 2));
		var tex_center_y = (uvs[1] + (tex_coord_height / 2));
	
		shader_set_uniform_f(texcoord_center_pos, tex_center_x, tex_center_y);
		shader_set_uniform_f(sprite_size_pos, sprite_get_width(spr_skinmenupizza), sprite_get_height(spr_skinmenupizza));
		shader_set_uniform_f(curve_pos, curve);
	}

	// The Pizza Matrix™
	var prev_matrix = matrix_get(matrix_world);
	if (anim_t < 1 && !global.performance)
		shader_set_uniform_f(origin_pos, (SCREEN_WIDTH / 2) - bg_pos, (SCREEN_HEIGHT / 2) - bg_pos);
	matrix_set(matrix_world, matrix_build(round(bg_pos), round(bg_pos), 0, 0, 0, 0, 1, 1, 1));
	gpu_set_blendmode(bm_normal);
	vertex_submit(pizza_vbuffer, pr_trianglelist, sprite_get_texture(spr_skinmenupizza, bg_image));
	matrix_set(matrix_world, prev_matrix);
	shader_reset();
}

if curve < 1
	draw_set_spotlight(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, spotlight_size, true);
else
	toggle_alphafix(true);

with obj_transfotip
{
	if visible
	{
		draw_set_colour(c_black);
		
		var xx = SCREEN_WIDTH / 2;
		var yy = SCREEN_HEIGHT - 50;
		var s = text_size;
		
		xx -= (s[0] / 2);
		yy -= s[1];
		
		draw_set_alpha(fade / 2);
		draw_roundrect(xx - 16, yy - 10, xx + s[0] + 16, yy + s[1], false);
		draw_set_alpha(1);
	}
}

// draw content
draw_set_colour(c_white);
if is_method(draw)
	draw(curve);
shader_reset();

// post draw content
if is_method(postdraw)
	postdraw(curve);

while surface_get_target() != obj_screensizer.gui_surf
	surface_reset_target();

draw_reset_clip();
toggle_alphafix(true);
