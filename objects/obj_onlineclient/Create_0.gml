// @description Initialization

// Enums
#macro online_delay 2

enum online_state
{
	disabled,
	connecting,
	connected,
	dead
}

enum tcp_message
{
	unknown,
	
	credentials,
	chat,
	
	room_change,
	delete_player,
	kick,
}

// Sockets
address = "cuonl.pizzatowertogether.com";
port = 6300;
tcp_socket = undefined;
udp_socket = undefined;

// State
uuid = undefined;
username = concat("Guest_", irandom_range(1000, 9999));
state = online_state.disabled;
clients = ds_map_create();
chat = ds_list_create(); // { name: string, body: string }

scr_online_init();
scr_online_connect(address, port);
instance_create(0, 0, obj_onlinechat);

alarm[1] = online_delay;
