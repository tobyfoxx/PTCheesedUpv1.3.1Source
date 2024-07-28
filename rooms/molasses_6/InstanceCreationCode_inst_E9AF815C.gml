condition = function()
{
    return place_meeting(x, y, obj_player1) && obj_player1.state == states.freefallland;
}

output = function()
{
    secret_open_portalID();
    with instance_place(x, y + 1, obj_solid)
        y += 32;
	
	if !in_saveroom(other.id, other.flags.saveroom)
    {
		shake_camera(20, 40 / room_speed);
        sound_play_centered(sfx_breakblock);
        sound_play_centered(sfx_breakmetal);
		with instance_place(x, y, obj_player1)
			y += 32;
		
		if REMIX
		{
			fmod_event_instance_set_parameter(global.snd_secretwall, "state", check_char("SP") or check_char("SN"), false);
			fmod_event_instance_play(global.snd_secretwall);
		}
    }
	
    var lay_id = layer_get_id("Tiles_6");
    layer_y(lay_id, 32);
}
