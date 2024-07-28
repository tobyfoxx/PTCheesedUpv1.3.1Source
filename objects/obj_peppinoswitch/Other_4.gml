if (scr_ispeppino(obj_player1))
{
	if (!obj_player1.isgustavo)
		sprite_index = spr_gustavosign;
	else
	{
		with (obj_gustavoswitch)
			sprite_index = spr_pepsign;
	}
}
else if (!obj_player1.noisecrusher)
	sprite_index = spr_noisesign;
else
{
	with (obj_gustavoswitch)
		sprite_index = spr_noisesign;
}

if obj_player1.character == "G"
{
	if !instance_exists(obj_gustavoblock)
	{
		var panic = escape;
		if global.panic
			panic = !panic;
		
		with instance_create(x, y + 14, obj_teleporter)
		{
			start = panic ? 0 : 2;
			trigger = noone;
			
			event_perform(ev_other, ev_room_start);
		}
	}
	instance_destroy();
}
