global.roommessage = "WELCOME TO PIZZA TOWER";
if (!obj_secretmanager.init)
{
	obj_secretmanager.init = true;
	secret_add(noone, function()
	{
		secret_open_portal(0);
	});
	secret_add(noone, function()
	{
		secret_open_portal(1);
	});
}
