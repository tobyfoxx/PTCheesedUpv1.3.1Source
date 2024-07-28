#macro lstr lang_get_value_newline

function scr_get_languages()
{
	global.lang_map = ds_map_create();
	//global.skin_map = ds_map_create();
	global.lang = "en";
	
	// languages
	var root = "data/lang/";
	for (var file = file_find_first(concat(root, "*.txt"), 0); file != ""; file = file_find_next())
	{
		var str = buffer_load(concat(root, file));
		lang_parse(buffer_read(str, buffer_text));
		buffer_delete(str);
	}
	file_find_close();
	
	// palettes
	/*
	var root = "data/lang/";
	for (var file = file_find_first(concat(root, "*.json"), 0); file != ""; file = file_find_next())
	{
		var str = buffer_load(concat(root, file));
		var json = json_parse(buffer_read(str, buffer_text));
		if is_struct(json)
			ds_map_set(global.skin_map, json.lang, json);
		buffer_delete(str);
	}
	file_find_close();
	*/
	
	global.credits_arr = scr_lang_get_credits();
}

function lang_parse_file(filename)
{
	var str = buffer_load(filename);
	var key = lang_parse(buffer_read(str, buffer_text));
	buffer_delete(str);
	
	//if lang_get_value_raw(key, "custom_graphics")
	//	lang_sprites_parse(key);
}

function scr_lang_get_file_arr(filename)
{
	var fo = file_text_open_read(filename);
	var arr = [];
	while fo != -1 && !file_text_eof(fo)
	{
		array_push(arr, file_text_read_string(fo));
		file_text_readln(fo);
	}
	file_text_close(fo);
	return arr;
}

function scr_lang_get_credits()
{
	return scr_lang_get_file_arr("data/credits.txt");
}

function scr_lang_get_noise_credits()
{
	var arr = scr_lang_get_file_arr("data/noisecredits.txt");
	var credits = [];
	for (var i = 0; i < array_length(arr); i++)
	{
		var _name = arr[i++];
		var _heads = array_create(0);
		for (var _head = arr[i++]; _head != ""; _head = arr[i++])
		{
			array_push(_heads, real(_head) - 1);
			if i >= array_length(arr)
				break;
		}
		i--;
		array_push(credits, 
		{
			name: _name,
			heads: _heads
		});
	}
	return credits;
}

function lang_get_value_raw(lang, entry)
{
	var n = ds_map_find_value(ds_map_find_value(global.lang_map, lang), entry);
	if is_undefined(n)
		n = ds_map_find_value(ds_map_find_value(global.lang_map, "en"), entry);
	if is_undefined(n)
	{
		n = "";
		instance_create_unique(0, 0, obj_langerror);
		with obj_langerror
			text = concat("Error: Could not find lang value \"", entry, "\"\nPlease restore your english.txt file");
	}
	return n;
}

function lang_get_value(entry)
{
	return lang_get_value_raw(global.lang, entry);
}

function lang_get_value_newline(entry)
{
	return string_replace_all(lang_get_value(entry), "\\n", "\n");
}

function lang_parse(langstring) // langstring being the entire file in a single string
{
	var list = ds_list_create();
	lang_lexer(list, langstring);
	
	var map = lang_exec(list);
	var lang = map[? "lang"];
	
	if ds_map_exists(global.lang_map, lang)
		lang_exec(list, global.lang_map[? lang]);
	else
		ds_map_set(global.lang_map, lang, map);
	
	ds_list_destroy(list);
	return lang;
}

enum lexer
{
	set,
	name,
	value,
	keyword,
	eof
}

function lang_lexer(list, str)
{
	var len = string_length(str);
	var pos = 1;
	while pos <= len
	{
		var start = pos;
		var char = string_ord_at(str, pos);
		pos += 1;
		
		switch (char)
		{
			case ord(" "):
			case ord("	"): // horizontal tab
			case ord("\r"): // carriage return
			case ord("\n"): // newline
				break;
			
			case ord("#"):
				while pos <= len
				{
					char = string_ord_at(str, pos);
					if char == ord("\r") || char == ord("\n")
						break;
					pos += 1;
				}
				break;
			
			case ord("="):
				ds_list_add(list, [lexer.set, start]);
				break;
			
			case ord("\""):
				while pos <= len
				{
					char = string_ord_at(str, pos);
					if char != ord("\"") || string_ord_at(str, pos - 1) == ord("\\")
						pos += 1;
					else
						break;
				}
				
				if pos <= len
				{
					var val = string_copy(str, start + 1, pos - start - 1);
					val = string_replace_all(val, "\\\"", "\""); // sertif forgot the "val = "
					ds_list_add(list, [lexer.value, start, val]);
					pos += 1;
				}
				else
					exit;
				
				break;
			
			default:
				if lang_get_identifier(char, false)
				{
					while pos <= len
					{
						char = string_ord_at(str, pos);
						if lang_get_identifier(char, true)
							pos += 1;
						else
							break;
					}
					
					var name = string_copy(str, start, pos - start);
					switch name
					{
						case "false":
							ds_list_add(list, [lexer.keyword, start, false]);
							break;
						case "noone":
							ds_list_add(list, [lexer.keyword, start, noone]);
							break
						case "true":
							ds_list_add(list, [lexer.keyword, start, true]);
							break;
						default:
							ds_list_add(list, [lexer.name, start, name]);
					}
				}
				break;
		}
	}
	ds_list_add(list, [lexer.eof, len + 1]);
}

function lang_get_identifier(keycode, allow_numbers)
{
	if allow_numbers
		return keycode == ord("_") || (keycode >= ord("a") && keycode <= ord("z")) || (keycode >= ord("A") && keycode <= ord("Z")) || (keycode >= ord("0") && keycode <= ord("9"));
	else
		return keycode == ord("_") || (keycode >= ord("a") && keycode <= ord("z")) || (keycode >= ord("A") && keycode <= ord("Z"));
}

function lang_exec(token_list, map = ds_map_create()) // HAHAHA
{
	var len = ds_list_size(token_list);
	
	var pos = 0;
	while pos < len
	{
		var q = ds_list_find_value(token_list, pos++);
		switch q[0]
		{
			case lexer.set: // 0 is enum
				var ident = array_get(ds_list_find_value(token_list, pos - 2), 2);
				var val = array_get(ds_list_find_value(token_list, pos++), 2);
				ds_map_set(map, ident, val);
				break;
		}
	}
	return map;
}

function lang_get_custom_font(fontname, language)
{
	var _dir = concat(fontname, "_dir");
	var _ttf = ds_map_find_value(language, "use_ttf");
	
	if !is_undefined(ds_map_find_value(language, _dir))
	{
		if !is_undefined(_ttf) && _ttf
		{
			var font_size = ds_map_find_value(language, concat(fontname, "_size"));
			font_size = real(font_size);
			return font_add(concat("data/lang/", ds_map_find_value(language, _dir)), font_size, false, false, 32, 127);
		}
		else
		{
			try
			{
				var font_map = ds_map_find_value(language, concat(fontname, "_map"));
				var font_size = string_length(font_map);
				var font_sep = ds_map_find_value(language, concat(fontname, "_sep"));
		
				var font_xorig = 0;
				var font_yorig = 0;
			
				var path = concat("data/lang/", ds_map_find_value(language, _dir));
				trace("Path: ", path);
			
				var spr = sprite_add(path, font_size, false, false, font_xorig, font_yorig);
				trace(spr);
			
				if sprite_exists(spr)
					return font_add_sprite_ext(spr, font_map, 0, real(font_sep));
				else
					trace("File ", ds_map_find_value(language, _dir), " does not exist");
			}
			catch (e)
			{
				trace("Unable to add custom font ", fontname, " for language ", language.display_name, $"\n\n{e.longMessage}\n---\n\nstacktrace: {e.stacktrace}");
			}
		}
	}
	return lang_get_font(fontname);
}

function lang_get_font(fontname)
{
	/*
	if instance_exists(obj_modconfig)
	{
	}
	else if object_index == obj_tv or object_is_ancestor(object_index, par_choicebase)
	{
	}
	else if check_sugary()
	{
		if fontname == "bigfont"
			fontname = "bigfont_ss";
		if fontname == "smallfont"
			fontname = "smallfont_ss";
	}
	*/
	
	var n = ds_map_find_value(global.font_map, lang_get_value(fontname));
	if !is_undefined(n)
		return n;
	return ds_map_find_value(global.font_map, concat(fontname, "_en"));
}

// pto
function lang_value_exists(entry)
{
	var n = ds_map_find_value(ds_map_find_value(global.lang_map, global.lang), entry);
	if is_undefined(n)
		n = ds_map_find_value(ds_map_find_value(global.lang_map, "en"), entry);
	return !is_undefined(n);
}

function lang_switch(lang, do_sprites = true)
{
	static using_base = true;
	
	global.lang = lang;
	if is_undefined(ds_map_find_value(global.lang_map, lang))
	{
		global.lang = "en";
		exit;
	}
	
	trace("--- Lang switch ---");
	
	// load sprites
	var root = $"data/lang/sprites/{lang}/";
	ini_open(concat(root, "data.ini"));
	
	var error = 0;
	for (var file = file_find_first($"{root}*.*", 0); file != ""; file = file_find_next())
	{
		var filepath = concat(root, file);
		var sprite = filename_change_ext(file, "");
		
		trace("File found ", filepath, " sprite would be \"", sprite, "\"", " filename_ext ", filename_ext(file));
		
		if asset_get_type(sprite) != asset_sprite
			continue;
		
		if filename_ext(file) == ".png" or filename_ext(file) == ".gif"
		{
			using_base = false;
			if do_sprites
			{
				var images = ini_read_string(sprite, "images", "");
				var xoffset = ini_read_string(sprite, "xoffset", "");
				var yoffset = ini_read_string(sprite, "yoffset", "");
				if string_digits(images) != ""
					images = ini_read_real(sprite, "images", 0);
				else
					images = undefined;
				if string_digits(xoffset) != ""
					xoffset = ini_read_real(sprite, "xoffset", 0);
				else
					xoffset = undefined;
				if string_digits(yoffset) != ""
					yoffset = ini_read_real(sprite, "yoffset", 0);
				else
					yoffset = undefined;
			
				var sprind = asset_get_index(sprite);
				var size = image_get_size(filepath);
				if !is_array(size)
				{
					error = 1;
					continue;
				}
				
				sprite_replace(sprind, filepath, images ?? floor(size[0] / sprite_get_width(sprind)), false, 0, xoffset ?? sprite_get_xoffset(sprind), yoffset ?? sprite_get_yoffset(sprind));
			}
		}
		else
			continue;
		
		trace("Replaced sprite");
	}
	
	switch error
	{
		case 1:
			show_message(concat("Some custom sprites for language \"", lang, "\" failed to load."));
			break;
	}
	
	file_find_close();
	ini_close();
	
	return !using_base;
}
