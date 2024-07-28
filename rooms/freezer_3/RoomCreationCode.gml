pal_swap_init_system(shd_pal_swapper);
global.roommessage = "PIZZA TOWER ISLAND";
if global.panic or scr_isnoise(obj_player1)
{
	var lay = layer_get_id("Assets_2");
	layer_set_visible(lay, false);
}
