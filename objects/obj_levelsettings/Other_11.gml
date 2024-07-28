live_auto_call;
state = states.door;
with obj_startgate
{
	if place_meeting(x, y, obj_player1)
	{
		obj_player1.image_index = obj_player1.image_number - 1;
		obj_player1.state = states.victory;
		presscount = 2;
	}
}
