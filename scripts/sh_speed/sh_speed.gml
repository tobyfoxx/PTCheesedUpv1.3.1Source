function sh_speed(args)
{
	if !WC_debug
		return "You do not have permission to use this command";
	if array_length(args) < 2
		return "Missing argument: speed";
	
	var spd = args[1];
	if string_is_number(spd)
	{
		game_set_speed(real(spd), gamespeed_fps);
		return $"Set game speed to {game_get_speed(gamespeed_fps)}";
	}
	else
		return "Speed parameter must be a number";
}
function meta_speed()
{
	return {
		description: "set the game's maximum FPS. depending on your setup it might not go over 60",
		arguments: ["speed"],
		suggestions: [
			function()
			{
				if room_speed != 60
					return [60, room_speed];
				return [60];
			}
		],
		argumentDescriptions: [
			"the number to set the maximum FPS to",
		],
	}
}

