if !variable_global_exists("editorfont")
	global.editorfont = font_add_sprite_ext(spr_smallerfont, "ABCDEFGHIJKLMNOPQRSTUVWXYZ!.:?1234567890", true, -2);

with obj_cyop_loader
{
	if id != other.id
		instance_destroy();
}

// init
objects = cyop_objectlist();
_room = noone;
room_name = "";
room_ind = -1;

global.in_cyop = true;
global.cyop_sprites = ds_map_create();
global.cyop_tiles = ds_map_create();
global.cyop_audio = ds_map_create();
global.cyop_room_map = ds_map_create();
global.cyop_asset_cache = ds_map_create();
global.cyop_broken_tiles = ds_list_create();

loaded = false;
gamestart = false;
tile_surface = noone;
cam_x = -1;
cam_y = -1;
