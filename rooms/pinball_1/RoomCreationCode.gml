global.roommessage = "PIZZA TOWER ISLAND";
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
		if (secret_check_trigger(1))
			secret_open_portal(1);
	});
}
