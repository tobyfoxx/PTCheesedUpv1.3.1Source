if !REMIX
	instance_destroy();

flags.do_once = false;
flags.do_save = false;

condition = function()
{
	with obj_player
	{
		if place_meeting(x, y, other) && (sprite_index == spr_mach2jump or sprite_index == spr_playerBN_grindJump) && state == states.mach2 && vsp < 0 && xscale == 1
			return id;
	}
	return false;
}
output = function(player)
{
	player.state = states.mach3;
	player.sprite_index = player.spr_mach4;
	player.movespeed = max(player.movespeed, 10);
}
