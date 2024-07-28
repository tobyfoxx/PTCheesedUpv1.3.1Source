if alarm[0] > 0
	exit;
if !active or !self.state or !instance_exists(obj_pause)
	exit;
if !global.richpresence
{
	np_clearpresence();
	exit;
}

// prep
var smallimagetext = "", largeimagetext = DEBUG ? "TEST" : GM_version;
var state = "", details = "", largeimage = "", smallimage = "";

largeimage = "big_icon";

// player character
if instance_exists(obj_player1)
{
	character = obj_player1.character;
	if obj_player1.isgustavo && character != "N"
		character = "G";
	if character == "PP" or character == "CT" or character == "PN" or character == "PUFFER"
		character = "";
}

smallimage = $"char_{string_lower(character)}";
smallimagetext = $"Playing as {scr_charactername(character, character == "G")}";

// status
if room == Mainmenu or room == Longintro or room == characterselect or room == Finalintro
	details = "Pre-Game";
else
	details = global.sandbox ? "Playing Sandbox" : "Playing Story";

if obj_pause.pause
	details = "Paused";
else if global.panic
{
	var minutes = 0;
	for (var seconds = ceil(global.fill / 12); seconds > 59; seconds -= 60)
		minutes++;
	if seconds < 10
		seconds = concat("0", seconds);
	
	if global.laps >= 2 && global.lapmode == lapmode.laphell
		details = $"Lap {global.laps + 1}";
	else if global.laps > 0
		details = string("Lap {0} - {1}:{2} left", global.laps + 1, minutes, seconds);
	else
		details = string("Escaping - {0}:{1} left", minutes, seconds);
}
else if !instance_exists(obj_cyop_loader)
{
	var stack = [];
	if MOD.CTOPLaps
		array_push(stack, "Lappable");
	if MOD.Encore
		array_push(stack, "Encore");
	if MOD.Mirror
		array_push(stack, MOD.HardMode or MOD.EasyMode ? "Mirrored" : "Mirror Mode");
	if MOD.EasyMode
		array_push(stack, MOD.HardMode ? "Easy" : "Easy Mode");
	if MOD.HardMode
		array_push(stack, "Hard Mode");
	if MOD.JohnGhost
		array_push(stack, "John Ghost");
	if MOD.Pacifist
		array_push(stack, "Pacifist");
	if MOD.Spotlight
		array_push(stack, "Lights Out");
	if MOD.GravityJump
		array_push(stack, "VVVVVV");
	if MOD.DoubleTrouble
		array_push(stack, "Double Trouble");
	if MOD.Hydra
		array_push(stack, "Hydra");
	if MOD.GreenDemon
		array_push(stack, "Green Demon");
	if MOD.FromTheTop
		array_push(stack, "From The Top");
	if MOD.OldLevels
		array_push(stack, "on old levels");
	
	if array_length(stack)
	{
		if array_length(stack) > 2
			details = "";
		else
			details = "Playing";
		
		while array_length(stack)
			details += $" {array_shift(stack)}";
	}
}
else
{
	details = "Playing CYOP";
	if global.cyop_level_name != "Level Name" && global.cyop_level_name != ""
		state = string(global.cyop_level_name);
	else
		state = string(global.cyop_tower_name);
}

if global.goodmode
	details = "Enduring Good Mode";

if !instance_exists(obj_startgate)
{
	// level
	switch global.leveltosave
	{
		case "entrance": state = MOD.NoiseGutter ? "Noise Gutter" : "John Gutter"; break;
		case "medieval": state = "Pizzascape"; break;
		case "ruin": state = "Ancient Cheese"; break;
		case "dungeon": state = "Bloodsauce Dungeon"; break;
		case "badland": state = "Oregano Desert"; break;
		case "graveyard": state = "Wasteyard"; break;
		case "farm": state = "Fun Farm"; break;
		case "saloon": state = "Fast Food Saloon"; break;
		case "plage": state = "Crust Cove"; break;
		case "forest": state = "Gnome Forest"; break;
		case "space": state = "Deep-Dish 9"; break;
		case "minigolf": state = "GOLF"; break;
		case "street": state = "The Pig City"; break;
		case "sewer": state = "Oh Shit!"; break;
		case "industrial": state = "Peppibot Factory"; break;
		case "freezer": state = "R.R.F."; break;
		case "chateau": state = "Pizzascare"; break;
		case "kidsparty": state = "Don't Make A Sound"; break;
		case "war": state = "WAR"; break;
		case "exit": state = "CTOP"; break;
		case "secretworld": state = "Secrets Of The World"; break;
	
		// pto
		case "desert": state = "Old Desert"; break;
		case "beach": state = "Pineapple Beach"; break;
		case "factory": state = "April Factory"; break;
		case "city": state = "Old City"; break;
		case "oldsewer": state = "Old Shit!"; break;
		case "oldfactory": state = "Old Factory"; break;
		case "oldfreezer": state = "Old Freezer"; break;
		case "golf": state = "Old GOLF"; break;
		case "pinball": state = "Space Pinball"; break;
		case "top": state = "Top"; break;
		case "oldexit": state = "Exit"; break;
		case "strongcold": state = "Strongcold"; break;
		case "dragonlair": state = "Dragon's Lair"; break;
		case "snickchallenge": state = "Snick's Challenge"; break;
	
		case "midway": state = "Midway"; break;
		case "sky": state = "Sky"; break;
		case "ancient": state = "Ancient Tower"; break;
		case "etb": state = "Early Test Build"; break;
		case "grinch": state = "Grinch Race"; break;
		case "whitespace": state = "What Lies Beyond?"; break;
	
		// sugary
		case "entryway": state = "Crunchy Construction"; break;
		case "steamy": state = "Cottontown"; break;
		case "mines": state = "Sugarshack Mines"; break;
		case "molasses": state = "Molasses Swamp"; break;
		case "dance": state = "Dance Off" break;
		case "estate": state = "Choco Cafe"; break;
		case "mountain": state = "Mt. Fudgetop"; break;
		case "sucrose": state = "Sucrose Snowstorm"; break;
	}

	// add rank and score
	if state != ""
	{
		var rank = "?";
		if global.collect >= global.srank
			rank = scr_is_p_rank() ? "P" : "S";
		else if global.collect >= global.arank
			rank = "A";
		else if global.collect >= global.brank
			rank = "B";
		else if global.collect >= global.crank
			rank = "C";
		else
			rank = "D";
	
		state += string(" - {0} ({1})", global.collect, rank);
	
		// Pizzascape - 10000 (S)
	}
}

// not a level
if state == ""
{
	var r = room_get_name(room);
	
	// tower floors
	if string_starts_with(r, "tower_")
	{
		var f = string_digits(r);
		
		if room == tower_entrancehall
			state = "Tower Entrance";
		if room == tower_johngutterhall
			state = "John Gutter Hall";
		if f == "1"
			state = "Tower Lobby";
		if f == "2"
			state = "Western District";
		if f == "3"
			state = "Vacation Resort";
		if f == "4"
			state = "Slum";
		if f == "5"
			state = "Staff Only";
		if room == tower_laundryroom
			state = "Wash 'n' Clean";
		if room == tower_mansion
			state = "Tower Mansion";
		if room == tower_noisettecafe
			state = "Noisette's Café";
		if room == tower_pizzafacehall
			state = "Tower's Unknown";
		if room == tower_pizzaland
			state = "Pizzaland";
		if room == tower_graffiti
			state = "Mr. Car";
		if room == tower_ravine
			state = "Ravine";
		if room == tower_ruinsecret
			state = "Old Tower";
		if room == tower_finalhallway
			state = "Control Room";
		if room == tower_soundtest
			state = "Sound Test";
		if room == tower_outside
			state = "Tower Outside";
		if string_pos("tutorial", r) > 0
			state = "Tutorial";
		
		// pto
		if room == tower_extra
			state = "Scrap Basement";
		if room == tower_extra2
			state = "Extra Tower";
		if room == tower_sugary
			state = "The Sugary Spire";
		if room == tower_hubroomE
			state = "Abandoned Tower";
		if room == tower_baby
			state = "Baby Room";
		if room == tower_freerun
			state = "Freerunning";
	}
	
	if string_starts_with(r, "trickytreat_")
	{
		state = "Tricky Treat";
		if instance_exists(obj_pumpkincounter)
			state += $" - {obj_pumpkincounter.counter} left";
	}
	
	if string_starts_with(r, "tutorialV_")
		state = "Tutorial";
	
	// cutscenes
	if room == Loadiingroom
		state = "Loading...";
	if room == Mainmenu
		state = "Main Menu";
	if room == timesuproom
		state = "Time's Up!";
	if room == Longintro
		state = "Are you ready?";
	if room == Finalintro
		state = "Cliff Cutscene";
	if room == Endingroom
		state = "Ending";
	if room == Creditsroom
		state = "Credits";
	if room == Johnresurrectionroom
		state = "Ending";
	if room == characterselect
		state = "Character Select";
	if room == editor_entrance
		state = "Custom Towers";
	
	if room == Initroom
		state = "Disclaimer";
	if room == room_cancelled
		state = "Message";
	
	// bosses
	if room == boss_pepperman
		state = "Pepperman";
	if room == boss_vigilante
		state = character == "V" ? "The Green" : "Vigilante";
	if room == boss_noise
		state = character == "N" ? "The Doise" : "The Noise";
	if room == boss_fakepep or room == boss_fakepepkey or room == boss_fakepephallway
		state = "Fake Peppino";
	if room == boss_pizzaface or room == boss_pizzafacefinale
		state = "Pizzaface";
	if room == boss_pizzafacehub
		state = "Top of the Pizza Tower";
}
if room == rank_room
	state = "Ranking";

if instance_exists(obj_modconfig)
	state = "Browsing the modded config";

np_setpresence(state, details, largeimage, smallimage);
np_setpresence_more(smallimagetext, largeimagetext, false);
