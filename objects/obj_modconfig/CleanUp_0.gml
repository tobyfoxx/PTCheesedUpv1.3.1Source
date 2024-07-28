live_auto_call;

surface_free(global.modsurf);
if layer_exists(sequence_layer)
	layer_destroy(sequence_layer);

while array_length(sections_array)
{
	var sect = array_pop(sections_array);
	sect.dispose();
}
