live_auto_call;

open_menu();
con = 0;
fade = 0;

//720x400
surf = -1;
output = "";
input_mode = 0;
input = "";
blink = 0;
scroll = 0;
echo = true;

bordersurf = -1;

instructions = [];
instructionT = 0;
instructionF = -1;

draw_set_font(fnt_dos);
lineh = string_height("A");
keyboard_string = "";

#region FUNCS

function DOS_instruct(delay, func) {
	array_push(instructions, [delay, func]);
}
function DOS_initstate2()
{
	output += "\n";
	if echo
	{
		output += currentdir.ROOTNAME;
		output += ">";
	}
	input_mode = 1;
}
function DOS_initstate()
{
	// C:\>
	output += "\n";
	DOS_instruct(3, DOS_initstate2);
}
function DOS_allargs(args, input = "", after = 1, sep = " ")
{
	var ret = "";
	if input == ""
	{
		for(var i = after; i < array_length(args); i++)
		{
			ret += args[i];
			if i != array_length(args) - 1
				ret += sep;
		}
		return ret;
	}
	else
	{
		for(var i = 0; i < after; i++)
		{
			ret += args[i];
			if i != array_length(args) - 1
				ret += sep;
		}
		return string_replace_all(input, ret, "");
	}
}
function DOS_command(IN = input)
{
	input_mode = 0;
	
	if string_replace_all(IN, " ", "") == ""
		DOS_initstate2();
	else
	{
		output += "\n";
		
		// process
		var args_raw = string_split_ext(IN, [" ", "\\", "/"], true, infinity);
		var args = [];
		
		for(var i = 0; i < array_length(args_raw); i++)
		{
			if string_pos(".", args_raw[i]) != 0
			{
				var fuck = string_split(args_raw[i], ".", false, infinity);
				for(var j = 0; j < array_length(fuck); j++)
				{
					if fuck[j] != ""
						array_push(args, fuck[j]);
					if j != array_length(fuck) - 1
						array_push(args, ".");
				}
			}
			else
				array_push(args, args_raw[i]);
		}
		
		switch string_lower(args[0])
		{
			#region RUN
			
			default:
				var emptyhanded = true;
				for(var j = 0; j < array_length(currentdir.CONTENT); j++)
				{
					var file = currentdir.CONTENT[j];
					var filename = string_lower(file.NAME);
					
					var pos = string_pos(".", filename);
					if pos != 0
						filename = string_copy(filename, 1, string_pos(".", filename) - 1);
					
					if file.TYPE == 0 && filename == string_lower(args[0])
					{
						if is_method(file.FUNC)
						{
							input_mode = 0;
							file.FUNC();
						}
						emptyhanded = false;
					}
				}
				
				if emptyhanded
				{
					output += lstr("msdos_bad"); // Bad command or file name
					output += "\n";
					DOS_instruct(3, DOS_initstate2);
				}
				break;
			
			#endregion
			#region CLS
			
			case "cls":
				output = "";
				DOS_instruct(3, DOS_initstate2);
				break;
			
			#endregion
			#region CD
			
			case "cd":
			case "chdir":
				var revert = currentdir;
				if array_length(args) == 1
					output += revert.ROOTNAME + "\n";
				else
				{
					for(var i = 1; i < array_length(args); i++)
					{
						var cur = args[i], last = i == array_length(args) - 1;
						if cur == "." && !last && args[i + 1] == "."
						{
							if currentdir.DIR == -1
							{
								output += lstr("msdos_invalid");
								output += "\n";
								currentdir = revert;
								break;
							}
							else
								currentdir = currentdir.DIR;
							i++;
						}
						else if cur == "."
						{
							// do nothing
						}
						else
						{
							var emptyhanded = true;
							for(var j = 0; j < array_length(currentdir.CONTENT); j++)
							{
								var file = currentdir.CONTENT[j];
								if file.TYPE == 1 && string_upper(file.NAME) == string_upper(args[i])
								{
									currentdir = file;
									emptyhanded = false;
								}
							}
						
							if emptyhanded
							{
								output += lstr("msdos_invalid");
								output += "\n";
								currentdir = revert;
								break;
							}
						}
					}
				}
				DOS_instruct(3, DOS_initstate2);
				break;
			
			#endregion
			#region HELP
			
			case "help":
				switch progression
				{
					default: output += lstr("msdos_help"); break;
					case 0: case 1: case 2: case 3: case 4: case 5:
					case 7: case 8: case 9: case 10:
						output += lstr(concat("msdos_help", progression));
						progression++;
						break;
					case 6:
					case 6.1:
						if currentdir.NAME == "1985"
						{
							output += lstr("msdos_help6");
							progression = 7;
						}
						else if currentdir.NAME != root.NAME
						{
							output += lstr("msdos_help90");
							progression = 6.1;
						}
						else
						{
							output += progression == 6 ? lstr("msdos_help91") : choose(lstr("msdos_help92"), lstr("msdos_help93"), lstr("msdos_help94"));
							progression = 6.1;
						}
						break;
					case 11:
						output += "marior";
						progression++;
						break;
					case 12:
						output += lstr(embed_value_string("msdos_help12", ["marior"]));
						break;
				}
				output += "\n";
				DOS_instruct(3, DOS_initstate2);
				break;
			
			#endregion
			#region ECHO
			
			case "echo":
				if array_length(args) == 2 && args[1] == "on"
					echo = true;
				else if array_length(args) == 2 && args[1] == "off"
					echo = false;
				else if array_length(args) > 1
				{
					for(var i = 1; i < array_length(args); i++)
						output += args[i] + " ";
					output += "\n";
				}
				else
					output += $"ECHO is {(echo ? "on" : "off")}\n";
				DOS_instruct(3, DOS_initstate2);
				break;
			
			#endregion
			#region CALL
			
			case "call":
				DOS_command(DOS_allargs(args, IN));
				break;
			
			#endregion
			#region EXIT
			
			case "exit":
				output += "\n";
				DOS_instruct(50, function()
				{
					obj_player1.state = states.normal;
					instance_destroy();
				});
				break;
			
			#endregion
			#region MKDIR
			
			case "mkdir":
			case "md":
				if array_length(args) == 1
				{
					output += lstr("msdos_short");
					output += "\n";
				}
				else
				{
					var emptyhanded = true;
					for(var j = 0; j < array_length(currentdir.CONTENT); j++)
					{
						var allargs = string_upper(DOS_allargs(args, IN));
						
						var file = currentdir.CONTENT[j];
						if file.TYPE == 1 && (file.NAME == allargs or file.ROOTNAME == allargs)
						{
							emptyhanded = false;
							break;
						}
					}
					
					if emptyhanded
						DOS_adddir(DOS_directory(string_upper(DOS_allargs(args, IN))), currentdir);
					else
					{
						output += lstr("msdos_exists");
						output += "\n";
					}
				}
				DOS_instruct(3, DOS_initstate2);
				break;
			
			#endregion
			#region RMDIR
			
			case "rmdir":
				if array_length(args) == 1
				{
					output += lstr("msdos_short");
					output += "\n";
				}
				else
				{
					var revert = currentdir;
					
					var emptyhanded = true;
					for(var j = 0; j < array_length(currentdir.CONTENT); j++)
					{
						var allargs = string_upper(DOS_allargs(args, IN));
						
						var file = currentdir.CONTENT[j];
						if file.TYPE == 1 && (file.NAME == allargs or file.ROOTNAME == allargs)
						{
							currentdir = file;
							emptyhanded = false;
						}
					}
					if !emptyhanded && array_length(currentdir.CONTENT) == 0
						currentdir.TYPE = -1; // mark as deleted
					else
					{
						output += lstr("msdos_invalid2");
						output += "\n";
					}
					currentdir = revert;
				}
				DOS_instruct(3, DOS_initstate2);
				break;
			
			#endregion
			#region UNSUPPORTED
			
			case "dir":
			case "move":
			case "del":
			case "ren":
				output += lstr("msdos_ominous");
				output += "\n";
				DOS_instruct(3, DOS_initstate2);
				break;
			
			#endregion
		}
	}
}
function DOS_directory(name)
{
	return {TYPE: 1, NAME: name, CONTENT: [], DIR: -1, ROOTNAME: name};
}
function DOS_adddir(file, dir)
{
	if string_ends_with(dir.ROOTNAME, "\\")
		file.ROOTNAME = concat(dir.ROOTNAME, file.ROOTNAME);
	else
		file.ROOTNAME = concat(dir.ROOTNAME, "\\", file.ROOTNAME);
	file.DIR = dir;
	array_push(dir.CONTENT, file);
}
function DOS_file(dir, name, func)
{
	var file = {TYPE: 0, NAME: name, FUNC: func,
		DATE: 0, SIZE: 0};
	array_push(dir.CONTENT, file);
	return file;
}

#endregion

DOS_instruct(50, function() {output = lstr("msdos_start1")});
DOS_instruct(100, function() {output += "\n"; output += lstr("msdos_start2")});
DOS_instruct(10, DOS_initstate);

#region FOLDER STRUCTURE

root = DOS_directory("C:\\");

var folder = DOS_directory("1985");
DOS_adddir(folder, root);

var mario = DOS_file(folder, "marior", function()
{
	output = "";
	
	var lag = 3;
	DOS_instruct(lag, function() {output += "@@@@@@@@@@&&&@@@@@@@@@@@@@@%%%%#&%%%%##(((#%%%%%&%%%%%@@@@@@@@@@@@@@@&@@&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@&&&@@@@@@@@@@@@@@%%%&((###############((%%%%@@@@@@@@@@@@@@@&@@&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@&&&@@@@@@@@@@@@@@#(#######..	, *%######(%@@@@@@@@@@@@@@@&@@&@@@&@@@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@&&&@@@@@@@@@@@@/(#######. ,(#(/(#(...%%%%%####@@@@@@@@@@@@@&@@&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@&&@&&&&&&&&&&/(########/./##  % .##*.%%%%%%%%##%@@@@@@@@@@@&@@&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@&&&&&&&&&&&&(######%%%%%/.%.....,,%.%%%%%%%%%%%#(&&&&&&&&&&&@@&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@&&&&&&&&&&&(#####%%%%%##((#############%%%%%%%%%#(&&&&&&&&&&&@&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@%%%%%%%%%%%(####%%#%%%%%%%%%%%%%%%%%%%%%%%%%#&%%%%#(%%%%%%%%%%&&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@%%%%%%%%%%#(##%#%%%%&@@@@@%/////////@@@@@@%%%%%#%%##%%%%%%%%%%%@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@%%%%%%%%%%(###%%%((/@*|***#@*******@|**//(@/((&%%%%#%%%%%%%%%%%@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@&&&&&&&&&&&(#%%#,,***/,..#%#,,,,,**%%#,*/|****%&&%%(%%%%%%%%%%&@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@ ..,##,...,  %/# %*..,,,#% %//,*****&&%|**(&&&&&&&&&&@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@###########.***,##%....  #(%&*.......(%&|*,*,,*,&&#**///##########@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@&##########,,,**#% ....... ............,,,,,,*,,/&%(**/#%%%%%%%%%%@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@&&&&&&&&&&&..,.&../%%&@#,..........,,,,,*%&&&&**/#/|**&&&&&&&&&&&@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@@,.....*&&&%%%*,,,,,,,,,,,**&@@&&&@**.***#@@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@@@%#* .,,**&&&&&(*********&@@@@&*****.*%&@@@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@@@%#&&.,,,,,,*/,%&@@@@@@@@(/(*******,&&&&@@@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@@@@@@@@@**,,,,..,,,,,*************/&@@@@@@@@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@@@&%%%%#%(&&|**,,,...,********(&%#%%%%%%&@@@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@@@&%(########%@&&(***////#&&&&&%%%%%%%%%&@@@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@@@&############&#####%%&&&&&&&%%%%%%%%%%%#@@@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@@@%#######%######&############%%%%&%%%%%%%%%%%@@@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@@@@@########%%#.....(%##############....,(%&&&%%%%%%@@@@@@@@@@@@&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@&&&&&&&&&&%######%%%%(#....*#%##############%.,,,*%#&&&&%%%%%#&&&&&&&&&&&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@@@@@%######%%%%%(#####%&(################&##%%%%%&&&&%%##%%#@@@@@@@@@@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@@@@#%&#######%%%&@#(###############################%%&&&%%###%%%(@#%@@@@@@@\n";});
	DOS_instruct(lag, function() {output += "&&&&&&&@	  ##%%%&&@########################%%%%#%#####%&@&%%%##*	. @&&&&&&@@@\n";});
	DOS_instruct(lag, function() {output += "@@@@@%,	  ...,&&&&&##############################%%%%%%%@&%%(		  (&@&@@@@@@\n";});
	DOS_instruct(lag, function() {output += "@@@&		 ..,*/(@&&#######################%%%%%%%%%%%%%#&&@...		  .*#@@@\n";});
	DOS_instruct(lag, function() {output += "&&		 .....,(%&&&#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&@/.			..,&@@@@\n";});
	DOS_instruct(lag, function() {output += "%		 .......*%&%%%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%&&,			 .../@@@\n";});
	DOS_instruct(lag, function() {output += "*	   ...*//,..,(&&%%(##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%##.  .*/,.	....,,@@\n";});
	DOS_instruct(lag, function() {output += "@ .........*/.,..,/%%&%#######%%%%%&%%%%%%%%%&%%%%%%%%%%%%&&#%...,	  ..**,***@@\n";});
	DOS_instruct(lag, function() {output += "@@@,,..,...,,//.**@@%%(#########%%%%&&&%%&&&&%%%%######%%%#&&@@,,*/. ...*|***(@@\n";});
	DOS_instruct(lag, function() {output += "&&&&&%(,**(%%%(###@%%%###########%%%&&%&&&&&%##########%%%%&&%@%###%%%|***(%&@@@\n";});
	DOS_instruct(lag, function() {output += "&&&&&%%%%%%%%%(##%%%%(###########%%%&&%&%%%%############%%%%%%%&###%%%%#%%%%&@@@\n";});
	DOS_instruct(lag, function() {output += "&&&&&%%%%%%%%%(%%%%%%(##########%%%%&%%%%%%%############%%%#&&&&&&#%%%%#%%%%&@@@\n";});
	DOS_instruct(lag, function() {output += "&@&&&%%%%%%%%%%%%%%%############%%%%&%&&%%%##############%%%%%%%%%%%%%%#%%%%&@&@\n";});
	DOS_instruct(lag, function() {output += "&@&@@#%%%%&&&&&&&&&&(##########%%%%%%&&&&&&%#############%%%#&&&&&&&&&%#%%%%@@%@\n";});
	DOS_instruct(lag, function() {output += "&@&@@@@@@&&&&&&&&&&############%%%%%%&&&%%%%##############%%#&&&&&&&&&&%@@@@@@%@\n";});
	DOS_instruct(lag, function() {output += "&@&@@@@@%%%%%%%%%%&(##########%%%%%%&&&&%%%%###############%%#&&&&&&&&&&&@@@@@%@\n";});
	DOS_instruct(lag, function() {output += "&@&@@@@@@@@@@@&@@@############%%%%%%&&&&&&&&&###############%%&@@@&@@@@@@@@@@@%@\n";});
	DOS_instruct(lag, function() {output += "&@&@@@@@@@@@@@&%(*//((###%%###%%%%%%&&&&&&&&&#########%###(((/|*%%&@@@@@@@@@@@%@\n";});
	DOS_instruct(lag, function() {output += "&@&@@@@@@@@@@(////////(((####%%%%%%%%%%%&&&&#####%#((((((///////(/(&@@@@@@@@@@%@\n";});
	DOS_instruct(lag, function() {output += "&@&&&&&&&&&&////|****/((((###%%%%%%#%%%%%%%%%((((((((((|***////(((((%&&&&&&&&&&@\n";});
	DOS_instruct(lag, function() {output += "&&&&&&&&&&&&/(((((///(((((####%####(&&&&&&&&&((((((((((((//(((((((##(%%%%%%%%%%&\n";});
	DOS_instruct(lag, function() {output += "&@&&&&&&&&&&#((((((((#######%#####/////////////####((((((((((#######&&&&&&&&&&&@\n";});
	DOS_instruct(lag, function() {output += "&@@#((((((((((/#%%%%%%%%%%%#(((&%%&&&&&&@@@@@@%%%#,*/#%%%%%%%%%%%#/((((((((((%@@\n";});
	repeat 10
		DOS_instruct(lag, function() {output += "\n";});
	DOS_instruct(lag, function() {output = "";});
	DOS_instruct(100, function()
	{
		ini_open_from_string(obj_savesystem.ini_str_options);
		if !ini_read_real("Palettes", "mario", false)
		{
			with instance_create(0, 0, obj_cheftask)
			{
				achievement_spr = noone;
				sprite_index = spr_newclothes;
				paletteselect = 12;
				texture = spr_pattern_mario;
			}
			ini_write_real("Palettes", "mario", true);
			gamesave_async_save_options();
		}
		obj_savesystem.ini_str_options = ini_close();
		output = lstr("msdos_congratulation");
		output += "\n";
	});
	DOS_instruct(100, function() {output += lstr("msdos_pause"); output += "\n"; input_mode = 2;});
});
mario.SIZE = 64;
mario.DATE = date_create_datetime(1985, 8, 13, 0, 0, 0);

trace(root);

#endregion

currentdir = root;
progression = 0;

with obj_shell
	WC_bindsenabled = false;
