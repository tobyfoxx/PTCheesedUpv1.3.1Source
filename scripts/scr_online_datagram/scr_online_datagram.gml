function scr_online_datagram()
{
	online
	{	
		if !instance_exists(obj_player1) || state != online_state.connected
			exit;
		
		with obj_player1
		{
			var buffer = buffer_create(dgram_size, buffer_fixed, 1);
			
			buffer_write(buffer, buffer_u32, other.uuid);
			
			buffer_write(buffer, buffer_s32, x);
			buffer_write(buffer, buffer_s32, y);
			
			buffer_write(buffer, buffer_u32, sprite_index);
			buffer_write(buffer, buffer_u16, state);
			buffer_write(buffer, buffer_s8, xscale);
			buffer_write(buffer, buffer_u8, scr_online_convert_character(character));
			
			buffer_write(buffer, buffer_u8, paletteselect);
			buffer_write(buffer, buffer_u32, global.palettetexture);
			buffer_write(buffer, buffer_s8, hat + 1); // LOY FIX THIS (replace 0 with hat index)
			buffer_write(buffer, buffer_s8, pet + 1); // LOY FIX THIS (replace 0 with pet index)
			
			buffer_write(buffer, buffer_u16, min(global.laps + global.panic, 100));
			
			network_send_udp_raw(other.udp_socket, other.address, other.port, buffer, dgram_size);
			buffer_delete(buffer);
		}
	}
}
