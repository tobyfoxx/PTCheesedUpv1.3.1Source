live_auto_call;

//create_particle(x, y, part.genericpoofeffect);

if instance_exists(obj_onlineclient)
{
	online if ds_exists(clients, ds_type_map)
		ds_map_delete(clients, other.uuid);
}

scr_online_destroysounds();
