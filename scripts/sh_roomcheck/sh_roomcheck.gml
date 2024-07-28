function sh_roomcheck()
{
	if !WC_debug
		return "You do not have permission to use this command";
	instance_create_unique(0, 0, obj_roomcheck);
}
function meta_roomcheck()
{
	return {
		description: "base game command",
	}
}
