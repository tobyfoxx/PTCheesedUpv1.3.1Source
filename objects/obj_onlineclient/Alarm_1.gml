/// @description scr_online_datagram
if state == online_state.connected
	scr_online_datagram();
else if state == online_state.dead && instance_exists(obj_player)
{
	with obj_pause
	{
		hub = false;
		event_perform(ev_alarm, 3);
	}
}
alarm[1] = online_delay;
