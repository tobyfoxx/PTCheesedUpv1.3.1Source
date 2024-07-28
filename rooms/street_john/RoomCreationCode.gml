global.roommessage = "GRANNY PIG'S HOUSE";

var lay_id = layer_get_id("Assets_stillBG1")
var gus = layer_sprite_get_id(lay_id, "gustv")
var noise = layer_sprite_get_id(lay_id, "noisetv2")
if scr_ispeppino()
{
	layer_sprite_alpha(gus, 1)
	layer_sprite_alpha(noise, 0)
}
else
{
	layer_sprite_alpha(gus, 0)
	layer_sprite_alpha(noise, 1)
}

if (!obj_secretmanager.init)
{
	obj_secretmanager.init = true;
	secret_add(function()
	{
		touchedtriggers = 0;
	}, function()
	{
		if (touchedtriggers >= 6)
			secret_open_portal(0);
	});
	secret_add(noone, function()
	{
		secret_open_portal(1);
	});
	secret_add(noone, function()
	{
		if (secret_check_trigger(2))
			secret_open_portal(2);
	});
}
