function scr_draw_screen(x, y, xscale, yscale, alpha = 1, gui = false)
{
	if live_call(x, y, xscale, yscale, alpha, gui) return live_result;
	
	if !surface_exists(application_surface)
		exit;
	
	x = floor(x);
	y = floor(y);
	
	// sugary spire greyscale
	with obj_camera
	{
		if greyscale > 0
		{
			shader_set(shd_greyscale);
			var fader = shader_get_uniform(shd_greyscale, "fade");
			shader_set_uniform_f(fader, greyscale);
		}
	}
	
	// draw the game
	var mirror = MOD.Mirror && !instance_exists(obj_rank);
	var flip = (safe_get(obj_player1, "gravityjump") && !MOD.GravityJump);
	var col = c_white;
	
	draw_surface_ext(application_surface, x + (mirror ? surface_get_width(application_surface) * xscale : 0), y + (flip ? surface_get_height(application_surface) * yscale : 0), xscale * (mirror ? -1 : 1), yscale * (flip ? -1 : 1), 0, col, alpha);
	shader_reset();
	
	if MOD.Birthday
	{
		var blend = gpu_get_state();
		
		gpu_set_blendmode_ext(bm_src_alpha, bm_one);
		gpu_set_blendenable(true);
		col = #ff99ff;
		draw_set_alpha(0.2);
		draw_rectangle_color(x, y, x + surface_get_width(application_surface) * xscale, y + surface_get_height(application_surface) * yscale, col, col, col, col, 0);
		draw_set_alpha(1);
		
		gpu_set_state(blend);
	}
}
