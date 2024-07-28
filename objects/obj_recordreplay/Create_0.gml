live_auto_call;

with obj_recordreplay
{
	if id != other.id
		instance_destroy();
}

buffer = buffer_create(64, buffer_grow, 1);
time = 0;

prev = {r: -4};

var expect_version = 0;
room_restart();

// header
buffer_write(buffer, buffer_u8, expect_version); // version
buffer_write(buffer, buffer_text, "REP"); // 82 69 80

// modded config
buffer_write(buffer, buffer_u8, global.iteration);
buffer_write(buffer, buffer_bool, global.gameplay);
buffer_write(buffer, buffer_bool, global.uppercut);
buffer_write(buffer, buffer_bool, global.poundjump);
buffer_write(buffer, buffer_u8, global.attackstyle);
buffer_write(buffer, buffer_u8, global.shootstyle);
buffer_write(buffer, buffer_u8, global.doublegrab);
buffer_write(buffer, buffer_u8, global.shootbutton);
buffer_write(buffer, buffer_bool, global.heatmeter);
buffer_write(buffer, buffer_bool, global.swapgrab);
buffer_write(buffer, buffer_u8, global.holidayoverride > -1 ? global.holidayoverride : global.holiday);
buffer_write(buffer, buffer_u8, global.vigisuperjump);
buffer_write(buffer, buffer_bool, global.sugaryoverride);
buffer_write(buffer, buffer_u8, global.lapmode);
buffer_write(buffer, buffer_bool, global.parrypizzaface);
buffer_write(buffer, buffer_bool, global.lap3checkpoint);
buffer_write(buffer, buffer_bool, global.lap4checkpoint);
buffer_write(buffer, buffer_u8, global.chasekind);

// player
buffer_write(buffer, buffer_string, obj_player1.character);
buffer_write(buffer, buffer_bool, obj_player1.noisetype);
buffer_write(buffer, buffer_u8, obj_player1.paletteselect);

var pattern;
if global.palettetexture == noone
	pattern = "";
else
{
	pattern = sprite_get_name(global.palettetexture);
	pattern = string_replace(pattern, "spr_", "");
	pattern = string_replace(pattern, "pattern_", "");
	pattern = string_replace(pattern, "peppattern", "");
}
buffer_write(buffer, buffer_string, pattern);

// modifiers
var level = global.leveltosave ?? noone;
if level == noone
	level = "";
buffer_write(buffer, buffer_string, level);

var modifiers = 0;
modifiers |= MOD.Encore;
modifiers |= MOD.Pacifist << 1;
modifiers |= MOD.NoToppings << 2;
modifiers |= MOD.HardMode << 3;
modifiers |= MOD.Mirror << 4;
modifiers |= MOD.DeathMode << 5;
modifiers |= MOD.JohnGhost << 6;
modifiers |= MOD.Spotlight << 7;
modifiers |= MOD.CosmicClones << 8;
modifiers |= MOD.FromTheTop << 9;
modifiers |= MOD.GravityJump << 10;
modifiers |= MOD.GreenDemon << 11;
modifiers |= MOD.CTOPLaps << 12;
modifiers |= MOD.EasyMode << 13;
modifiers |= MOD.DoubleTrouble << 14;
modifiers |= MOD.Hydra << 15;

buffer_write(buffer, buffer_u32, modifiers);

// misc
buffer_write(buffer, buffer_bool, obj_inputAssigner.player_input_device[0] < 0 ? global.keyboard_superjump : global.gamepad_superjump);
buffer_write(buffer, buffer_bool, obj_inputAssigner.player_input_device[0] < 0 ? global.keyboard_groundpound : global.gamepad_groundpound);
