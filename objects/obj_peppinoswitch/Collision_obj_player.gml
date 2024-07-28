if (global.switchbuffer == 0 && global.panic == escape)
{
	with (other)
	{
		hsp = 0;
		vsp = 0;
		visible = false;
		state = states.actor;
	}
	sound_play("event:/sfx/misc/pepgusswitch");
	create_particle(x, y, part.genericpoofeffect);
	sprite_index = switchstart;
	playerid = other.id;
	global.switchbuffer = 200;
	with (obj_gustavoswitch)
	{
		sprite_index = switchend;
		image_index = 0;
	}
	with instance_create(0, 0, obj_charswitch_intro)
		spr = scr_charswitch_sprite(false);
}
