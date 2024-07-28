/// @description Networking
if async_load[? "id"] == udp_socket
	scr_online_udp(async_load);
else
	scr_online_tcp(async_load);
