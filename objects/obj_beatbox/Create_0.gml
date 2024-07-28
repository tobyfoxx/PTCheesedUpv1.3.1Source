init_collision();

vsp = -11;
depth = -3;
snd = fmod_event_create_instance("event:/sfx/misc/breakdancemusic");
playerid = obj_player1;

switch playerid.character
{
	case "BN": fmod_event_instance_set_parameter(snd, "state", 3, true); break;
	case "N": sprite_index = spr_beatboxN; break;
	case "V": sprite_index = spr_beatboxV; break;
}

sound_instance_move(snd, x, y);
fmod_event_instance_play(snd);
sound_play_3d("event:/sfx/misc/breakdance", playerid.x, playerid.y);
