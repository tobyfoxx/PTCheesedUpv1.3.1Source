image_speed = 0.35;
depth = 0;
snd = fmod_event_create_instance("event:/music/boss/noisette");
if global.jukebox != noone
	exit;

fmod_event_instance_play(snd);
with (obj_music)
{
	if (music != noone)
		fmod_event_instance_stop(music.event, false);
}
