if buffer > 0
	buffer--;

if state == 1
{
	anim_t = Approach(anim_t, 1, 0.1);
	if obj_player1.state != states.actor
	{
		state = 3;
		close_menu();
	}
	else if buffer <= 0
	{
		open_menu();
		scr_menu_getinput();
		
		var move = -key_up2 + key_down2;
		if move == 0
			move = -(key_left2 + key_right2);
		
		if move != 0
		{
			var selprev = sel;
			sel = clamp(sel + move, 0, array_length(hub_array) - 1);
			
			if sel != selprev
				sound_play_centered(sfx_step);
		}
		
		if key_jump
		{
			state = 2;
			close_menu();
		}
		else if key_back
		{
			sound_play_centered(sfx_enemyprojectile);
			state = 3;
			
			if obj_player1.isgustavo
				obj_player1.state = states.ratmount;
			else
				obj_player1.state = states.normal;
			
			close_menu();
		}
	}
}

if state == 2
{
	var hub = hub_array[sel];
	obj_player1.targetRoom = hub[1];
	obj_player1.targetDoor = hub[2];
	
	if obj_player1.targetRoom != room
	{
		sound_play_3d(sfx_keyunlock, x, y);
		sound_play_3d("event:/sfx/misc/elevatorstart", x, y);
		
		state = 3;
		sound_play(sfx_door);
		
		obj_camera.chargecamera = 0;
		with obj_player1
		{
			set_lastroom();
			sprite_index = isgustavo ? spr_ratmountenterdoor : spr_lookdoor;
			//image_index = 0;
			state = states.door;
			mach2 = 0;
		}
		with instance_create(x, y, obj_fadeout)
		{
			group_arr = hub[3];
			offload_arr = other.offload_arr;
		}
	}
	else
	{
		sound_play_centered(sfx_enemyprojectile);
		state = 3;
		close_menu();
		
		if obj_player1.isgustavo
			obj_player1.state = states.ratmount;
		else
			obj_player1.state = states.normal;
	}
}
with obj_player1
{
	if state == states.actor
		image_speed = image_index >= image_number - 1 ? 0 : 0.35;
}

if state == 3
{
	anim_t = Approach(anim_t, 0, 0.2);
	if anim_t <= 0
		state = 0;
}
