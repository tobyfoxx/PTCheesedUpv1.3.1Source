#macro is_online (instance_exists(obj_onlineclient))
#macro online if !instance_exists(obj_onlineclient) show_error("You can't use an online block without a client instance.", true); with (obj_onlineclient)
#macro dgram_size 29
#macro online_version "a1.1.1"

function scr_online_fail()
{
	// failed to connect
	online
	{
		instance_destroy();
	}
}

function scr_online_boot()
{
	// kicked
	online
	{
		state = online_state.dead;
	}
}

function scr_online_init()
{
	online
	{
		var port = 6303;
		tcp_socket = network_create_socket_ext(network_socket_tcp, port);
		while tcp_socket < 0
		{
			port++;
			if port > 65535
				show_error("Failed to find an open port.", true);
			tcp_socket = network_create_socket_ext(network_socket_tcp, port);
		}
		udp_socket = network_create_socket_ext(network_socket_udp, port);
	}
}

function scr_online_set_username(username)
{
	online
	{
		var buffer_size = 3 + string_length(username) + string_length(online_version);
		var buffer = buffer_create(buffer_size, buffer_fixed, 1);
		
		buffer_write(buffer, buffer_u8, tcp_message.credentials);
		buffer_write(buffer, buffer_string, username);
		buffer_write(buffer, buffer_string, online_version);
		network_send_raw(tcp_socket, buffer, buffer_size);
		
		buffer_delete(buffer);
	}
}

function scr_online_shutdown()
{
	online
	{
		instance_destroy(obj_onlinechat);
		
		ds_map_destroy(clients);
		ds_list_destroy(chat);
		
		if !is_undefined(tcp_socket)
			network_destroy(tcp_socket);
		if !is_undefined(udp_socket)
			network_destroy(udp_socket);
		
		if state == online_state.connected
			message_show("DISCONNECTED.", false);
	}
}

function scr_online_connect(address = "127.0.0.1", port = 6300)
{
	online
	{
		network_connect_raw_async(tcp_socket, address, port);
		state = online_state.connecting;
		alarm[0] = 5 * room_speed; // times out in 5 seconds
	}
}

function scr_online_chat(str)
{
	online
	{
		var buffer = buffer_create(string_length(str) + 2, buffer_fixed, 1);
		buffer_write(buffer, buffer_u8, tcp_message.chat);
		buffer_write(buffer, buffer_string, str);
		network_send_raw(tcp_socket, buffer, string_length(str) + 2);
		buffer_delete(buffer);
	}
}

function draw_online_name(x, y, sprite, username)
{
	draw_set_font(global.font_small);
	draw_set_align(fa_center, fa_bottom);
	
	var xx = x, yy = y - sprite_get_height(sprite) / 2 + sprite_get_bbox_top(sprite);
	
	if global.online_name_smooth
		yy = Wave(yy - 3, yy + 3, 2, 0);
	
	draw_text(xx, yy, username);
}

enum online_characters
{
	peppino,
	noise,
	vigilante,
	gustavo,
	snick,
	
	pizzelle,
	pizzano,
	
	bonoise,
}

function scr_online_convert_character(character_letter) 
{
	switch character_letter
	{
		default: return online_characters.peppino;
		case "N": return online_characters.noise;
		case "V": return online_characters.vigilante;
		case "G": return online_characters.gustavo;
		case "S": return online_characters.snick;
		
		case "SP": return online_characters.pizzelle;
		case "SN": return online_characters.pizzano;
		
		case "BN": return online_characters.bonoise;
	}
}