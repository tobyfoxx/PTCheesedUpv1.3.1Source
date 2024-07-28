live_auto_call;

stop_music();
depth = -9999;
alarm[0] = room_speed * 3;
con = 0;

music = fmod_event_create_instance("event:/modded/mario");
txtsnd = fmod_event_create_instance("event:/modded/mariotalk");
