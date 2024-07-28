ini_open_from_string(obj_savesystem.ini_str);
if (!ini_key_exists("Ranks", "exit") && !global.sandbox) // checks if you beat the game on this savefile
or instance_exists(obj_cyop_loader)
{
	var tr = room;
	if variable_instance_exists(id, "targetRoom")
		tr = targetRoom;
	
	instance_change(obj_door, true);
	targetRoom = tr;
	
	event_perform_object(obj_door, ev_other, ev_room_start);
	ini_close();
	exit;
}
ini_close();

// elevator here
scr_create_uparrowhitbox();
depth = 99;
sprite_index = spr_elevatoropen;

state = 0;
targetDoor = "A";
sel = 0;

if global.panic
{
	instance_create(x + 50, y + 96, obj_rubble);
	instance_destroy();
}

outback = animcurve_get_channel(curve_menu, "outback");
incubic = animcurve_get_channel(curve_menu, "incubic");
anim_t = 0;
angle = 360;
scr_init_input();

// floors
hub_array = [];
function add_floor(button_index, target_room, target_door, group_arr = noone, offload_arr = noone)
{
	var a = [button_index, target_room, target_door, group_arr, offload_arr];
	array_push(hub_array, a);
	return a;
}

if !instance_exists(obj_cyop_loader)
{
	add_floor(5, tower_5, "E");
	add_floor(4, tower_4, "B");
	add_floor(3, tower_3, "C");
	add_floor(2, tower_2, "E");
	add_floor(1, tower_1, "E");
	
	if !global.goodmode
	{
		add_floor(0, tower_extra, "G");
		if SUGARY_SPIRE
			add_floor(6, tower_sugary, "A", ["sugarygroup"]);
		if DEBUG
			add_floor(7, tower_test, "A");
	}
}
else
	add_floor(1, room, "A");

offload_arr = noone;
buffer = 0;
