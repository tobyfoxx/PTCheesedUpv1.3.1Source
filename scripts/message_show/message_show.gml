function message_show(_msg, error = true, _t = 100)
{
	with obj_roomname
	{
		visible = true;
		showtext = true;
		global.roommessage = string_upper(_msg);
		yi = -50;
		alarm[0] = _t;
		if error
			sound_play_centered(sfx_hurt);
	}
}
