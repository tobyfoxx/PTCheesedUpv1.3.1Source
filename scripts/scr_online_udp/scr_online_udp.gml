function scr_online_udp(load)
{
	online
	{
		if !instance_exists(obj_player1)
			exit;
		var buffer = load[? "buffer"];
		
		var p_uuid = buffer_read(buffer, buffer_u32);
		if (p_uuid == uuid || p_uuid == 0) exit;
		if (is_undefined(clients[? p_uuid]))
		{
			with (instance_create(-999, -999, obj_otherplayer))
			{
				uuid = p_uuid;
				other.clients[? p_uuid] = id;
			}
		}
		
		with (clients[? p_uuid])
		{
			x = buffer_read(buffer, buffer_u32);
			y = buffer_read(buffer, buffer_u32);
			
			sprite_index = buffer_read(buffer, buffer_u32);
			state = buffer_read(buffer, buffer_u16);
			image_xscale = buffer_read(buffer, buffer_s8);
			
			var char = buffer_read(buffer, buffer_u8);
			if char != character
				scr_online_swapsounds(char);
			character = char;
			
			paletteselect = buffer_read(buffer, buffer_u8);
			pattern = buffer_read(buffer, buffer_u32);
			hat = buffer_read(buffer, buffer_u8) - 1;
			pet = buffer_read(buffer, buffer_u8) - 1;
			
			laps = buffer_read(buffer, buffer_u16);
			username = buffer_read(buffer, buffer_string);
				
			visible = true;
		}
	}
}