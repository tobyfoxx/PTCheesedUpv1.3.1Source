live_auto_call;

if PLAYTEST
{
	if ds_map_find_value(async_load, "id") == req
	{
		if ds_map_find_value(async_load, "status") == 0
		{
			try
			{
				str = ds_map_find_value(async_load, "result");
				if string_starts_with(str, "<")
					str = "That doesn't check out.\n\nMake sure you're logged in your main Discord account.\nAnd that you didn't misspell the password.";
				else
				{
					str = array_pop(string_split(string_replace(str, "!", ""), " ", false, infinity));
					
					date_set_timezone(timezone_utc);
					
					var day = current_day;
					var year = round(frac(current_year / 100) * 100);
					
					var hour = current_hour;
					if hour == 0
						hour = 12;
					if hour > 12
						hour -= 12; 
					
					var suffix;
					switch round(frac(day / 10) * 10)
					{
						default: suffix = "th"; break;
						case 1: suffix = "st"; break;
						case 2: suffix = "nd"; break;
						case 3: suffix = "rd"; break;
					}
					
					date_set_timezone(timezone_local);
					
					var supposed_string = $"{hour}{year}{day}{suffix}{hour}{day}";
					if str == supposed_string
					{
						str = "";
						instance_create_unique(0, 0, obj_surfback);
						room_restart();
						exit;
					}
					else
						show_message($"{str}\n{supposed_string}");
				}
			}
			catch (error)
			{
				trace("DISCLAIMER\nstr: ", str, "\nerror: ", error);
				str = "Server error!\nSomething went horribly wrong?\n\nYou may have the game blocked on your firewall.\nRestarting also might work, sometimes this breaks...";
			}
		}
		else
		{
			trace("DISCLAIMER\nstatus: ", async_load[? "status"]);
			str = "Server error!\nPlease check your internet connection.\n\nYou may have the game blocked on your firewall.\nRestarting also might work, sometimes this breaks...";
		}
		
		state = 1;
		audio_play_sound(sfx_pephurt, 0, false);
		
		/*
		self.str = "Nuh uh.";
		
		if ++count > 1
			self.str += $" x{count}";
		
		if count >= 1000
			room_goto(rm_baby);
		else if count >= 400
			self.str += "\nIf you get to 1000, you'll get a special price."
		else if count >= 300
			self.str += "\nWell then.";
		else if count >= 200
			self.str += "\nYou can stop now.";
		else if count >= 100
			self.str += "\nWow.";
		else if count >= 30
			self.str += "\nHow high can you go?";
		else if count >= 10
			self.str += "\nMight wanna close the game.";
		*/
	}
}
