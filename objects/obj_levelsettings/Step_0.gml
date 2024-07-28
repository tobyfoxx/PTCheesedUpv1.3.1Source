live_auto_call;
ensure_order;

with obj_player
{
	if image_index >= image_number - 1
		image_speed = 0;
}

switch menu
{
	case 0:
		if state == 0
		{
			scr_menu_getinput();
			var move = key_left2 + key_right2;
			if move != 0
				sel = !sel;
			if key_jump
			{
				if sel == 1
				{
					fmod_event_instance_set_parameter(global.snd_golfjingle, "state", 0, true);
					fmod_event_instance_play(global.snd_golfjingle);
				}
				else
				{
					anim_t = 0;
					state = 1;
				}
			}
			if --skip_buffer <= 0 && room != editor_entrance
			{
				if key_taunt2
					event_user(1);
			}
		}
		break;
	case 1:
		if state == 0
			event_inherited();
		break;
}

if instance_exists(obj_titlecard)
	fadealpha = obj_titlecard.fadealpha;
if instance_exists(obj_fadeout)
	fadealpha = obj_fadeout.fadealpha;

if safe_get(obj_titlecard, "start")
	instance_destroy();
