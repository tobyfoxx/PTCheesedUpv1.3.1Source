function pal_swap_reset()
{
	if global.performance
		exit;
	
	shader_set(global.Pal_Shader);
	shader_set_uniform_f(global.Pal_Index, 0);
	pattern_reset();
	cuspal_reset();
	
	shader_reset();
	if event_number == ev_gui
		reset_shader_fix();
}
