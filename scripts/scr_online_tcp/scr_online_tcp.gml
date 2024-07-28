function scr_online_tcp(load)
{
	online
	{
		if (load[? "type"]  != network_type_data) exit;
		var buffer = load[? "buffer"];
	
		//while (buffer_tell(buffer) < load[? "size"])
		{
			var type = buffer_read(buffer, buffer_u8);
			switch (type)
			{
				case tcp_message.credentials: // UUID and Username
					uuid = buffer_read(buffer, buffer_u32);
					if state != online_state.connected
					{
						scr_online_set_username(username);
						trace(string("Successfully Connected with port {0}.\nUUID is {1}.", port, uuid));
					}
					username = buffer_read(buffer, buffer_string);
					state = online_state.connected;
					break;
				
				case tcp_message.chat:
					var name = buffer_read(buffer, buffer_string);
					var body = buffer_read(buffer, buffer_string);
					if name == "Global"
						scr_chat_add(body);
					else
						scr_chat_add(string("{0}: {1}", name, body));
					break;
					
				case tcp_message.kick:
					var reason = buffer_read(buffer, buffer_string);
					if string_trim(reason) == "" or reason == "null"
						reason = "No reason provided."
					
					scr_online_boot();
					global_message(reason, 1);
					break;
				
				case tcp_message.delete_player:
					var p_uuid = buffer_read(buffer, buffer_u32);
					if !is_undefined(clients[? p_uuid])
						instance_destroy(clients[? p_uuid]);
					break;
				
				default:
					scr_online_boot();
					global_message("Unhandled message type: " + string(type), 1);
					break;
			}
		}
	}
}
