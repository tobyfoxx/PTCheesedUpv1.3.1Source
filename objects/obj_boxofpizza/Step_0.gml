if (global.horse)
	exit;

var hall = id;
with (obj_player)
{
	if (other.image_yscale == 1)
	{
		if (((key_down && !place_meeting(x, y + 1, obj_destructibles) && place_meeting(x, y + 1, other) && ((state == states.crouch || character == "S" || character == "M") || state == states.ratmountgroundpound || state == states.ratmountbounce || state == states.ratmountcrouch || state == states.machroll || (state == states.tumble && sprite_index == spr_dive))) || ((state == states.crouchslide || (state == states.tumble && key_down) || state == states.machcancel || state == states.UNKNOWN_1 || state == states.UNKNOWN_4 || state == states.freefall || state == states.freefallland) && !place_meeting(x, y + 1, obj_destructibles) && place_meeting(x, y + 1, other))) && !instance_exists(obj_fadeout) && state != states.door && state != states.comingoutdoor)
		{
			if character == "S"
				movespeed = 0;
			
			set_lastroom();
			box = true;
			targetDoor = hall.targetDoor;
			targetRoom = hall.targetRoom;
				
			x = hall.x;
			
			sprite_index = isgustavo ? spr_ratmount_downpizzabox : spr_downpizzabox;
			image_index = 0;
			if state != states.gotoplayer
				state = states.door;
			
			if !other.bo
				other.depth = -10;
			sound_play_3d(other.sound, x, y);
			mach2 = 0;
			obj_camera.chargecamera = 0;
		}
	}
	if (other.image_yscale == -1)
	{
		var forced = state == states.Sjump || state == states.machcancel || state == states.Sjumpland;
		
		if ((key_up or forced) && !place_meeting(x, y - 1, obj_destructibles) && place_meeting(x, y - 10, other) && !instance_exists(obj_fadeout)
		&& (state == states.normal || state == states.machcancel || state == states.pogo || state == states.UNKNOWN_1 || state == states.UNKNOWN_3 || state == states.machcancel || state == states.jump || state == states.mach1 || state == states.mach2 || state == states.mach3 || state == states.Sjumpprep || state == states.ratmount || state == states.ratmountjump || state == states.ratmountbounce || (state == states.punch && sprite_index == spr_breakdanceuppercut)
		or state == states.twirl or forced))
		{
			if character == "S"
				movespeed = 0;
			
			set_lastroom();
			box = true;
			targetDoor = hall.targetDoor;
			targetRoom = hall.targetRoom;
			vsp = 0;
				
			x = hall.x;
			y = hall.y + 24;
				
			sprite_index = isgustavo ? spr_ratmount_uppizzabox : spr_uppizzabox;
			image_index = 0;
			if state != states.gotoplayer
				state = states.door;
			
			sound_play_3d(other.sound, x, y);
			if !other.bo
				other.depth = -8;
			mach2 = 0;
			obj_camera.chargecamera = 0;
		}
	}
}

with instance_place(x, y + 1, obj_doorX)
	other.targetDoor = door;
with instance_place(x, y - 1, obj_doorX)
	other.targetDoor = door;
