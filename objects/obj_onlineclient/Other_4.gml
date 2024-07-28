/// @description Update room
var buffer = buffer_create(3, buffer_fixed, 1);
buffer_write(buffer, buffer_u8, tcp_message.room_change);
buffer_write(buffer, buffer_u16, room);
network_send_raw(tcp_socket, buffer, 3);
buffer_delete(buffer);
