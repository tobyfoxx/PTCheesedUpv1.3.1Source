live_auto_call;

fadein = false;
fadealpha = 0;
start = false;
loading = false;
group_arr = noone;
title_music = noone;
offload_arr = noone;

noisehead = [];
noisespot_buffermax = 10;
noisehead_pos = 0;
alarm[1] = 1;

depth = -600;
with obj_gusbrickchase
	fmod_event_instance_stop(snd, true);
with obj_gusbrickfightball
	alarm[1] = -1;

// pto
cyop_level = "";

modif_t = 0;
modifiers = [];
modif_con = 0;
modif_shake = 0;

var names = struct_get_names(MOD);
for(var i = 0; i < array_length(names); i++)
{
	if MOD[$ names[i]] > 0
	{
		switch names[i]
		{
			default: array_push(modifiers, 0); break;
			case "DeathMode": array_push(modifiers, 1); break;
			case "NoToppings": array_push(modifiers, 2); break;
			case "Pacifist": array_push(modifiers, 3); break;
			case "HardMode": array_push(modifiers, 4); break;
			case "Mirror": array_push(modifiers, 5); break;
			case "JohnGhost": array_push(modifiers, 7); break;
			case "Spotlight": array_push(modifiers, 8); break;
			case "CTOPLaps": array_push(modifiers, 6); break;
			case "DoubleTrouble": array_push(modifiers, 9); break;
			case "GreenDemon": array_push(modifiers, 10); break;
			
			//case "Encore": array_push(modifiers, 8); break;
			//case "NoiseGutter": array_push(modifiers, 8); break;
			//case "CosmicClones": array_push(modifiers, 8); break;
			//case "FromTheTop": array_push(modifiers, 8); break;
			//case "GravityJump": array_push(modifiers, 8); break;
			
			//case "OldLevels": array_push(modifiers, 8); break;
			//case "EasyMode": array_push(modifiers, 8); break;
			//case "Ordered": array_push(modifiers, 8); break;
			//case "SecretInclude": array_push(modifiers, 8); break;
		}
	}
}
