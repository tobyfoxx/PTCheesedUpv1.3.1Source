scr_create_uparrowhitbox();
flags.do_save = false;
condition = function()
{
	var player = instance_place(x, y, obj_player);
	return player && player.state == states.normal && player.grounded && player.key_up2;
}
output = function()
{
	with obj_uparrowhitbox
		if ID == other.id instance_destroy();
	
	with obj_player1
	{
		state = states.victory;
		sprite_index = isgustavo ? spr_ratmountenterdoor : spr_lookdoor;
	}
	
	with instance_create(x, y, obj_eventtrigger)
	{
		condition = function()
		{
			return obj_player1.image_index >= obj_player1.image_number - 1;
		}
		output = function()
		{
			instance_create(0, 0, obj_msdos);
		}
	}
}
