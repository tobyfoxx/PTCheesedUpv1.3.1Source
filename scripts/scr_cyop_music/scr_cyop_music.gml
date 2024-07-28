message = "don't steal my code shithead";

function cyop_music()
{
	music = noone;
	if current_custom != noone
	{
		var song = custom_music[current_custom];
		if song.fmod
		{
			if song.instance == noone
			{
				song.instance = fmod_event_create_instance(song.event);
				fmod_event_instance_set_parameter(song.instance, "state", song.state, false);
				fmod_event_instance_play(song.instance);
			}
			else
			{
				fmod_event_instance_set_paused(song.instance, false);
				song.paused = false;
			}
		}
		else
		{
			if song.instance == noone
				song.instance = audio_play_sound(song.event, 0, true, global.option_music_volume);
			else
			{
				var volume = 0.8;
				volume /= fmod_get_parameter("totem", false) * 2;
				volume *= 1 - fmod_get_parameter("pillarfade", false);
				
				audio_sound_gain(song.instance, global.option_music_volume * clamp(volume, 0, 1), 0);
				if audio_is_paused(song.instance)
					audio_resume_sound(song.instance);
			}
		}
	}
}
function cyop_freemusic()
{
	with obj_music
	{
		current_custom = noone;
		while array_length(custom_music) > 0
		{
			var i = array_pop(custom_music);
			if i.fmod
			{
				fmod_event_instance_stop(i.instance, true);
				fmod_event_instance_release(i.instance);
			}
			else
				audio_stop_sound(i.instance);
			delete i;
		}
	}
}
