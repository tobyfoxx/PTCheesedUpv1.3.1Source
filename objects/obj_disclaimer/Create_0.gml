live_auto_call;

state = 0;
are_you_sure = false;
fade_alpha = 1;
crash_image = noone;
crash_msg = noone;
disclaimer = noone;

// menus
make_firstboot_file = function()
{
	ini_open("saveData.ini");
	ini_write_real("Modded", "first_boot", 1);
	ini_close();
}

if file_exists("firstboot") or file_exists("first_boot") // the old one
{
	file_delete("firstboot");
	file_delete("first_boot");
	make_firstboot_file();
}

count = 0;
pto_textbox_init();

image_speed = 0.35;
menu = 0;
sel = 0;

options = noone;
saves = array_create(3, noone);
selected = [0, 0, 0, 0];
pizzashift = [0, 0];

// box
size = 0;
surf = noone;
t = 0;

outback = animcurve_get_channel(curve_menu, "outback");
incubic = animcurve_get_channel(curve_menu, "incubic");

// check availability
req = -1;
net = true; //os_is_network_connected(true);
str = "This is an anti-leaking measure.\n\nPlease connect to the internet to continue.\nYou may have the game blocked on your firewall.";

if file_exists("crash_log.txt") && (!PLAYTEST or instance_exists(obj_surfback))
{
	var file = buffer_load("crash_log.txt");
	try
	{
		crash_msg = json_parse(buffer_read(file, buffer_text));
		
		draw_set_font(lang_get_font("creditsfont"));
		text = scr_compile_icon_text("{u}Press [c] to play/");
		crash_image = sprite_add("crash_img.png", 1, 0, 0, 0, 0);
		
		menu = 3;
	}
	catch (e)
	{
		trace($"Failed to crash the log idiot {e}");
		file_delete("crash_log.txt");
		room_restart();
	}
	buffer_delete(file);
}
else if PLAYTEST && !instance_exists(obj_surfback)
{
	menu = 2;
	state = 1;
	net = true;
	str = "This is a playtester build for the mod.\nDo not share it anywhere.";
}
else
{
	net = true;
	state = 2;
	are_you_sure = true;
}
