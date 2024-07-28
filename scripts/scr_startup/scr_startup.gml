// optimizations
gml_pragma("forceinline");
surface_depth_disable(true); // disable the depth buffer.

function toggle_texture_debug(enable) {
	texturegroup_set_mode(true, enable, spr_missing);
}
toggle_texture_debug(false);

if YYC
{
	// room order check
	if room_first != Loadiingroom or room_next(room_first) != Initroom
	{
		show_message("Please do not modify this version of the game.");
		game_end();
		exit;
	}
	
	// drm
	global.collect2 = array_create(5, false);
	
	// nekopresence dll integrity
	// 4e16dcab5d51e96c4a75a474a14361c6
	
	if md5_file("NekoPresence_x64.dll") != concat(4, "e", 16, "dcab", 5, "d", 51, "e", 96, "c", 4, "a", 75, "a", 474, "a", 14361, "c", 6)
	{
		show_message(md5_file("NekoPresence_x64.dll"));
		game_end();
		exit;
	}
	
	if file_exists("dead")
	{
		game_end();
		exit;
	}
	
	if !file_exists("CheesyPizza.dll")
	{
		show_message("");
		game_end();
		exit;
	}
}
else
	debug_event("OutputDebugOn");

// crash handler
exception_unhandled_handler
(
	function(e)
	{
		// force stop all sound
		audio_stop_all();
		with obj_fmod
		{
			fmod_event_instance_set_paused_all(true);
			fmod_update();
		}
		
		// fallback to default audio engine for this
		audio_bus_main.bypass = true;
		audio_master_gain(1);
		audio_play_sound(sfx_pephurt, 0, false, global.option_master_volume * global.option_sfx_volume);
		
		// take a screenshot
		try
		{
			var surf = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT);
			surface_set_target(surf);
			
			draw_clear(c_black);
			gpu_set_blendmode_ext(bm_one, bm_inv_src_alpha);
			
			scr_draw_screen(0, 0, 1, 1, 1, true);
			if instance_exists(obj_screensizer) && surface_exists(obj_screensizer.gui_surf)
				draw_surface(obj_screensizer.gui_surf, 0, 0);
			
			gpu_set_blendmode(bm_normal);
			surface_reset_target();
			
			surface_save(surf, "crash_img.png");
			surface_free(surf);
		}
		catch (h)
		{
			trace(h);
		}
		
		// show and log the crash
	    show_debug_message(string(e));
		show_message($"The Cheese fucked Up!\n\n---\n\n{e.longMessage}\n---\n\nstacktrace: {e.stacktrace}");
		
		// save it to a file
		var _f = file_text_open_write("crash_log.txt");
		file_text_write_string(_f, json_stringify(e));
		file_text_close(_f);
	}
);

// drama
#macro DEATH_MODE false
#macro SUGARY_SPIRE true
#macro BO_NOISE true

// macros
#macro REMIX global.gameplay
#macro DEBUG (GM_build_type == "run")
#macro YYC (!DEBUG)
#macro PLAYTEST (!DEBUG)

#macro STRING_UNDEFINED "<undefined>"
#macro CAMX camera_get_view_x(view_camera[0])
#macro CAMY camera_get_view_y(view_camera[0])
#macro CAMW camera_get_view_width(view_camera[0])
#macro CAMH camera_get_view_height(view_camera[0])
#macro DATE_TIME_NOW concat(current_year, "-", current_month, "-", current_day, "__", current_hour, "-", current_minute, "-", current_second)
#macro PANIC ((global.panic or global.snickchallenge) && (!instance_exists(obj_ghostcollectibles) or global.leveltosave == "sucrose" or global.leveltosave == "secretworld"))

// initialize
scr_get_languages();
pal_swap_init_system_fix(shd_pal_swapper, true);
texture_debug_messages(DEBUG);

// fonts
global.bigfont = font_add_sprite_ext(spr_font, "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ!¡¿?.1234567890:ÁÄÃÀÂÉÈÊËÍÎÏÓÖÕÔÚÙÛÜÇ()[]',\"-_▼&#*", true, 0);
global.smallfont = font_add_sprite_ext(spr_smallerfont, "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ!¡.:?¿1234567890ÁÄÃÀÂÉÈÊËÍÎÏÓÖÕÔÚÙÛÜÇ", true, 0);
global.lapfont = font_add_sprite_ext(spr_lapfont, "1234567890", true, -1);
global.lapfont_ss = font_add_sprite_ext(spr_lapfont_ss, "1234567890", true, -1);
global.lapfont2 = font_add_sprite_ext(spr_lapfontbig, "0123456789", true, -2);
global.lapfont2_ss = font_add_sprite_ext(spr_lapfontbig_ss, "0123456789", true, -2);
//global.monitorfont = font_add_sprite_ext(spr_monitorfont, "1234567890", true, 1);
global.tutorialfont = font_add_sprite_ext(spr_tutorialfont, "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz!¡,.:0123456789'?¿-áäãàâæéèêëíîïóöõôúùûüÿŸÁÄÃÀÂÉÈÊËÍÎÏÓÖÕÔÚÙÛÜÇç", true, 2);
global.creditsfont = font_add_sprite_ext(spr_creditsfont, "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz.:!0123456789?'\"ÁÄÃÀÂÉÈÊËÍÎÏÓÖÕÔÚÙÛÜáäãàâéèêëíîïóöõôúùûüÇç_-[]▼()&#风雨廊桥전태양*яиБжидГзвбнль", true, 2);
global.moneyfont = font_add_sprite_ext(spr_stickmoney_font, "0123456789$-", true, 0);
global.font_small = font_add_sprite_ext(spr_smallfont, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!._1234567890:;?▯|*/',\"()=-+@█%~ÁÉÍÓÚáéíóúÑñ[]<>$", true, -1);
global.collectfont = font_add_sprite_ext(spr_font_collect, "0123456789", true, 0);
global.combofont = font_add_sprite_ext(spr_font_combo, "0123456789/:", true, 0);
global.combofont2 = font_add_sprite_ext(spr_tv_combobubbletext, "0123456789", true, 0);
global.combofont2BN = font_add_sprite_ext(spr_tv_combobubbletextBN, "0123456789", true, 0);
global.wartimerfont1 = font_add_sprite_ext(spr_wartimer_font1, "1234567890", true, 0);
global.wartimerfont2 = font_add_sprite_ext(spr_wartimer_font2, "1234567890", true, 0);
global.collectfontSP = font_add_sprite_ext(spr_font_collectSP, "0123456789", true, 0);
global.combofontSP = font_add_sprite_ext(spr_tv_combobubbletextSP, "1234567890x", true, 0);
global.collectfontBN = font_add_sprite_ext(spr_font_collectBN, "0123456789", true, 0);
global.sugarypromptfont = font_add_sprite_ext(spr_promptfont, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.:!0123456789?'\"ÁÉÍÓÚáéíóú_-[]▼()&#风雨廊桥전태양*яиБжидГзвбнль", true, 0)
global.candlefont = font_add_sprite_ext(spr_fontcandle, "0123456789", true, 0);
global.smallfont_ss = font_add_sprite_ext(spr_smallfont_ss, "ABCDEFGHIJKLMNOPQRSTUVWXYZ!.:?1234567890-", true, 0);
global.bigfont_ss = font_add_sprite_ext(spr_font_ss, "ABCDEFGHIJKLMNOPQRSTUVWXYZ!.0123456789:- ", true, -1);
global.smallnumber_fnt = font_add_sprite_ext(spr_smallnumber, "1234567890-+", true, 0);

// language font map
global.font_map = ds_map_create();

ds_map_set(global.font_map, "bigfont_en", global.bigfont);
ds_map_set(global.font_map, "smallfont_en", global.smallfont);
ds_map_set(global.font_map, "tutorialfont_en", global.tutorialfont);
ds_map_set(global.font_map, "creditsfont_en", global.creditsfont);
ds_map_set(global.font_map, "captionfont_en", fnt_caption);
ds_map_set(global.font_map, "font_small_en", global.font_small);
ds_map_set(global.font_map, "sugarypromptfont_en", global.sugarypromptfont);
ds_map_set(global.font_map, "smallfont_ss_en", global.smallfont_ss);
ds_map_set(global.font_map, "bigfont_ss_en", global.bigfont_ss);

// key = "en"
trace("--- Custom fonts --- size: ", ds_map_size(global.lang_map));

font_add_enable_aa(false);
for(var key = ds_map_find_first(global.lang_map); key != undefined; key = ds_map_find_next(global.lang_map, key))
{
	var lang = global.lang_map[? key]; // {lang: "en", text1: "", ...}
	if lang[? "custom_fonts"] != true
		continue;
	
	show_message("Custom fonts are not currently supported!");
	break;
	
	trace("Loading fonts for language ", lang[? "display_name"]);
	
	var font = ds_map_find_first(global.font_map);
	while font != undefined
	{
		ds_map_set(global.font_map, string_replace(font, "_en", concat("_", key)), lang_get_custom_font(string_replace(font, "_en", ""), lang));
		font = ds_map_find_next(global.font_map, font);
	}
}

// settings
global.custom_patterns = ds_map_create();
global.lap4time = 1;

function load_custom_palettes()
{
	for(var i = ds_map_find_first(global.custom_patterns); i != undefined; i = ds_map_find_next(global.custom_patterns, i))
		sprite_delete(global.custom_patterns[? i]);
	ds_map_clear(global.custom_patterns);
	
	global.custom_palettes = [];
	
	var root = "palettes/";
	for (var file = file_find_first(concat(root, "*.json"), 0); file != ""; file = file_find_next())
	{
		var str = buffer_load(concat(root, file));
		var json = json_parse(buffer_read(str, buffer_text));
		if is_struct(json)
			array_push(global.custom_palettes, json);
		buffer_delete(str);
	}
	
	for (var file = file_find_first(concat(root, "*.png"), 0); file != ""; file = file_find_next())
	{
		var spr = sprite_add(concat(root, file), 1, 0, 0, 0, 0);
		array_push(global.custom_patterns, spr);
	}
	file_find_close();
}

enum IT
{
	FINAL, // Do not change the order of these
	APRIL, // It would mess up savefiles.
	BNF
}
#macro IT_FINAL (global.iteration == IT.FINAL)
#macro IT_APRIL (global.iteration == IT.APRIL)
#macro IT_BNF (global.iteration == IT.BNF)

function load_moddedconfig()
{
	if instance_exists(obj_savesystem)
		ini_open_from_string(obj_savesystem.ini_str_options);
	else
		ini_open("saveData.ini");
	
	global.iteration = ini_read_real("Modded", "iteration", IT.FINAL);
	
	global.richpresence = ini_read_real("Modded", "richpresence", true);
	global.gameplay = ini_read_real("Modded", "gameplay", true); // misc. improvements on or off?
	global.experimental = ini_read_real("Modded", "experimental", DEBUG);
	global.performance = ini_read_real("Modded", "performance", false);
	
	// gameplay settings
	global.uppercut = ini_read_real("Modded", "uppercut", true); // *buffed uppercut*
	global.poundjump = ini_read_real("Modded", "poundjump", false);
	global.attackstyle = ini_read_real("Modded", "attackstyle", 0); // grab, kungfu, shoulderbash
	global.shootstyle = ini_read_real("Modded", "shootstyle", 0); // nothing, pistol, breakdance
	global.doublegrab = ini_read_real("Modded", "doublegrab", 0); // nothing, shoulderbash, tumble, chainsaw
	global.shootbutton = ini_read_real("Modded", "shootbutton", 0); // 0 replace grab, 1 move to A, 2 only shotgun
	global.heatmeter = ini_read_real("Modded", "heatmeter", false);
	global.swapgrab = ini_read_real("Modded", "swapgrab", false);
	global.unfocus_pause = ini_read_real("Modded", "unfocus_pause", false);
	global.border = ini_read_real("Modded", "border", -1); // -1 none, 0 space, 1 dynamic
	global.holidayoverride = ini_read_real("Modded", "holidayoverride", -1); // -1 default, 0 none, 1 etc
	global.vigisuperjump = 0; //ini_read_real("Modded", "vigisuperjump", 0); // 0 original, 1 bomb, 2 peppino
	global.hitstun = ini_read_real("Modded", "hitstun", 1); // 0 off, 1 on, 2 early
	
	// visual settings
	enum blockstyles
	{
		final,
		september,
		old
	}
	
	global.panicbg = ini_read_real("Modded", "panicbg", true);
	global.panictilt = ini_read_real("Modded", "panictilt", false);
	global.sloperot = ini_read_real("Modded", "sloperot", false);
	global.inputdisplay = ini_read_real("Modded", "inputdisplay", false);
	global.showfps = ini_read_real("Modded", "showfps", false);
	global.afterimage = ini_read_real("Modded", "afterimage", 0); // final, eggplant
	global.smoothcam = ini_read_real("Modded", "smoothcam", 0); // 0 through 1 lerp amount
	global.secrettiles = ini_read_real("Modded", "secrettiles", 0); // fade, spotlight
	global.hud = ini_read_real("Modded", "hud", 0); // final, old
	global.blockstyle = ini_read_real("Modded", "blockstyle", blockstyles.final); // final, september, old
	global.roomnames = ini_read_real("Modded", "roomnames", false);
	global.machsnd = ini_read_real("Modded", "machsnd", 0); // final, old
	global.sugaryoverride = ini_read_real("Modded", "sugaryoverride", false);
	global.enemyrot = ini_read_real("Modded", "enemyrot", false);
	
	// lapping
	enum lapmode
	{
		normal,
		infinite,
		laphell
	}
	global.lapmode = ini_read_real("Modded", "lapmode", lapmode.infinite); // normal, infinite, laphell
	global.parrypizzaface = ini_read_real("Modded", "parrypizzaface", true);
	global.lap3checkpoint = ini_read_real("Modded", "lap3checkpoint", true);
	global.lap4checkpoint = ini_read_real("Modded", "lap4checkpoint", true);
	global.chasekind = ini_read_real("Modded", "chasekind", 1); // none, place blocks, slow down
	
	// online
	enum bubble_style
	{
		off,
		pto,
		ptt
	}
	global.online_opacity = ini_read_real("Online", "opacity", 1);
	global.online_bubbles = ini_read_real("Online", "bubbles", bubble_style.pto);
	global.online_volume = ini_read_real("Online", "volume", 0.5);
	global.online_minichat = ini_read_real("Online", "minichat", false);
	global.online_name_opacity = ini_read_real("Online", "name_opacity", 1);
	global.online_name_smooth = ini_read_real("Online", "name_smooth", true);
	
	// convert from islam (PTT)
	if ini_key_exists("Modded", "pizzellesugaryoverride")
	{
		global.sugaryoverride = ini_read_real("Modded", "pizzellesugaryoverride", false);
		ini_key_delete("Modded", "pizzellesugaryoverride");
		ini_write_real("Modded", "sugaryoverride", global.sugaryoverride);
		
		global.vigisuperjump = ini_read_real("Modded", "vigisuperjump", 0) ? 2 : 0;
		ini_write_real("Modded", "vigisuperjump", global.vigisuperjump);
	}
	
	// PTU
	if ini_section_exists("ControlsKeysPTU")
		ini_section_delete("ControlsKeysPTU"); // REMOVES IT FROM CHEESED UP. NOT THE ORIGINAL FILE.
	if ini_section_exists("ControlsKeys2")
		ini_section_delete("ControlsKeys2");
	
	// fucked up
	if ini_key_exists("Modded", "infinitespeed")
	{
		show_message("PTFU modded config detected.\nShame on you. Removing it.");
		
		ini_key_delete("Modded", "infinitespeed");
		ini_key_delete("Modded", "spoilers");
		ini_key_delete("Modded", "sighting_2");
		ini_key_delete("Modded", "rpcstyle");
		ini_key_delete("Modded", "colorblind_type");
		ini_key_delete("Modded", "sugaryphysics");
	}
	
	// turn on performance mode
	if !shaders_are_supported() && !global.performance
	{
		show_message("It seems your device doesn't support shaders.\nPerformance mode has been turned on.");
		global.performance = true;
	}
	
	ini_close();
	
	// custom palettes
	load_custom_palettes();
}
load_moddedconfig();

// gameframe
ini_open("saveData.ini");

if os_version < 655360 or os_type != os_windows // below windows 10
{
	trace("Running on fucked up software, turned off gameframe");
	global.gameframe_enabled = false;
}
else
	toggle_gameframe(ini_read_real("Modded", "gameframe", true));

ini_close();

// etc
global.goodmode = false; // makes everything a living nightmare
global.sandbox = true;
global.saveloaded = false;

global.secrettile_clip_distance = 150; // distance before we cut off tiles
global.secrettile_fade_size = 0.85; // distance before we start to fade
global.secrettile_fade_intensity = 32; // dropoff intensity

#macro heat_nerf 5 // divides the style gain by this
#macro heat_lossdrop 0.1 // speed of global.style loss
#macro heat_timedrop 0.5 // speed of global.heattime countdown

// performance mode
#macro shader_set_base shader_set
#macro shader_set shader_set_fix
function shader_set_fix(shader)
{
	if global.performance
		exit;
	shader_set_base(shader);
}

// surface too big ORRY!
#macro surface_create_base surface_create
#macro surface_create surface_create_fix

function surface_create_fix(w, h, format = surface_rgba8unorm)
{
	if w > 16384 or h > 16384
		log_source("SURFACE TOO LARGE!");
	return surface_create_base(min(w, 16384), min(h, 16384), format);
}
