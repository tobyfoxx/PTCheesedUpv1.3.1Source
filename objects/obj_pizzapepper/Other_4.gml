if (global.panic == true && room != freezer_secret1)
	instance_destroy();
if (!instance_exists(obj_randomsecret) && room == freezer_secret1 && global.noisejetpack && (scr_ispeppino(obj_player1) || obj_player1.noisepizzapepper))
	instance_destroy();
