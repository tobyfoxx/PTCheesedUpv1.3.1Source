live_auto_call;

// prep
image_alpha = 0;
img = 0;

menu = 0;
state = 0;
fadealpha = 0;

anim_t = 0;
outback = animcurve_get_channel(curve_menu, "outback");
surface = -1;
clip_surface = -1;

skip_buffer = 5; // presing C again

event_inherited();
sel = 0;

var boss = false;
with obj_bossdoor
{
	if place_meeting(x, y, obj_player)
		boss = true;
}

#region MODIFIERS

function add_modifier(variable, local = string_lower(variable), drawfunc = noone)
{
	var struct = {
		type: modconfig.modifier,
		value: 0,
		vari: variable,
		name: lstr("mod_title_" + local),
		desc: lstr("mod_desc_" + local),
		opts: [["off", false], ["on", true]],
		drawfunc: drawfunc,
		condition: noone
	}
	array_push(options_array, struct);
	return struct;
}

options_array = [];
add_button("ok", function()
{
	reset_modifier();
	for(var i = 0; i < array_length(options_array); i++)
	{
		var opt = options_array[i];
		if opt.type == modconfig.modifier
			variable_struct_set(MOD, opt.vari, opt.opts[opt.value][1]);
	}
	event_user(1);
});

add_section("modifiers");
//add_modifier("Encore", MOD.Encore, "Remixes the level to make it harder.");

add_modifier("GreenDemon",, [seq_greendemon_off, seq_greendemon_on]);

if DEATH_MODE
{
	var deathmode_allow = 
	[ 
		"entryway", // Sugary
		"entrance", "medieval", //"ruin", "dungeon", // W1
		//"badland", "graveyard", "saloon", "farm", // W2
		//"plage", "space", "minigolf", "forest", // W3
		//"freezer", "street", "industrial", "sewer", // W4
		//"chateau", "kidsparty", //"war", // W5
		"etb", "midway", // Extra
	];
	if array_contains(deathmode_allow, level, 0, infinity)// or DEBUG
		add_modifier("DeathMode",, [seq_deathmode_off, seq_deathmode_on]);
}

if (level == "medieval" or level == "ruin" or level == "dungeon")
&& DEBUG
	add_modifier("OldLevels",, [seq_oldlevels_off, seq_oldlevels_on]);

if !boss && level != "tutorial" && global.experimental
	add_modifier("NoToppings",, [seq_notoppings_off, seq_notoppings_on]);
if !boss && level != "tutorial"
	add_modifier("Pacifist",, [seq_pacifist_off, seq_pacifist_on]);

add_modifier("HardMode",, [seq_hardmode_off, seq_hardmode_on]);
add_modifier("Mirror",, [seq_mirrored_off, seq_mirrored_on]);

/*
if !boss && level != "grinch" && level != "dragonlair" && level != "snickchallenge" && level != "tutorial" && level != "secretworld"
{
	var opt = add_modifier("Lap Hell", "Lap3", "A challenge awaits you on the third lap!", [seq_lap3_off, seq_lap3_on, seq_lap3_on]);
	opt.opts = [
		["OFF", false],
		["ON", true],
		["HARD", 2] // No parrying pizzaface, restart the whole level if failed
	]
}
*/

add_modifier("JohnGhost");

circle_size = 250;
add_modifier("Spotlight",, function(val)
{
	// draw circle first to crop out
	toggle_alphafix(false);
	
	draw_clear(c_black);
	circle_size = lerp(circle_size, val ? 70 : 250, 0.25);
	
	gpu_set_blendmode(bm_subtract);
	draw_circle(384/2 + random_range(-1, 1), 216/2 + random_range(-1, 1), circle_size, false);
	draw_set_alpha(0.35);
	draw_circle(384/2 + random_range(-1, 1), 216/2 + random_range(-1, 1), circle_size + 30, false);
	
	draw_set_alpha(1);
	toggle_alphafix(true);
	
	// player
	var p = simuplayer;
	draw_sprite(spr_playerN_move, p.image, 384 / 2, 216 / 2);
});

//if DEBUG // 2.0
{
	var l = level_info(level);
	if is_instanceof(l, __levelinfo) && global.experimental
		add_modifier("FromTheTop");
	
	add_modifier("GravityJump");
	
	add_modifier("DoubleTrouble");
	
	add_modifier("Hydra");
}

if global.experimental

// Level specific
if level == "grinch"
{
	add_section("level");
	add_modifier("EasyMode", "grincheasy");
}
if level == "golf"
{
	add_section("level");
	add_modifier("EasyMode", "golfeasy");
}
if level == "snickchallenge"
{
	add_section("level");
	add_modifier("OldLevels",, [seq_oldlevels_off, seq_oldlevels_on]);
	add_modifier("EasyMode", "snickeasy");
}
if level == "exit"
{
	add_section("level");
	add_modifier("CTOPLaps",, [seq_lappable_off, seq_lappable_on]);
}
if level == "secretworld"
{
	add_section("level");
	add_modifier("Ordered");
	add_modifier("SecretInclude");
	
	if DEBUG
		add_modifier("FromTheTop", "panic");
}
if level == "dragonlair"
{
	add_section("level");
	add_modifier("CTOPLaps",, [seq_lappable_off, seq_lappable_on]);
}

refresh_options();

#endregion
