live_auto_call;

if global.panic
	exit;
if (async_load[?"event_type"] != FMOD_BEAT_CALLBACK)
	exit;

desired_angle = (desired_angle + degree_per_beat) % 360;
anim_t = 0;
