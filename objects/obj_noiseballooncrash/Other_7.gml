instance_destroy();
if (scr_ispeppino(obj_player1))
	sound_play("event:/sfx/noise/giantballoon2");
fmod_event_instance_stop(snd, false);
fmod_event_instance_release(snd);
if (scr_isnoise(obj_player1))
	exit;
shake_camera(3, 5 / room_speed);
var layid = layer_get_id("Backgrounds_3");
layer_set_visible(layid, true);
with (obj_micnoise)
{
	with (instance_create(x, y, obj_sausageman_dead))
		sprite_index = spr_noisey_dead;
	instance_create(x, y, obj_bangeffect);
	instance_destroy();
}
