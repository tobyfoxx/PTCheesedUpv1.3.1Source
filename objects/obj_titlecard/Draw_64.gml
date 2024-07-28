live_auto_call;

// titlecard
toggle_alphafix(true);

draw_set_alpha(1);
if start
{
	var xscale = SCREEN_WIDTH / 960, yscale = SCREEN_HEIGHT / 540;
	
	if !instance_exists(obj_cyop_loader)
	{
		if REMIX && obj_player1.spr_palette == spr_peppalette
			pal_swap_player_palette(titlecard_sprite, titlecard_index, 1, 1);
		else
		{
			shader_set(global.Pal_Shader);
			pal_swap_set(spr_peppalette, 1);
		}
	}
	else
	{
		draw_rectangle_color(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0, false);
		draw_sprite(spr_cyop_fuckingidiot, 0, SCREEN_WIDTH - 10, SCREEN_HEIGHT - 10);
	}
	
	draw_sprite_ext(titlecard_sprite, titlecard_index, 0, 0, xscale, yscale, 0, c_white, 1);
	pal_swap_reset();
	draw_sprite_ext(title_sprite, title_index, 32 * xscale + irandom_range(-1, 1), irandom_range(-1, 1), xscale, yscale, 0, c_white, 1);
	
	for (var i = 0; i < array_length(noisehead); i++)
	{
		var head = noisehead[i];
		if !head.visible
			continue;
		
		head.visual_scale = Approach(head.visual_scale, 1, 0.25);
		draw_sprite_ext(spr_titlecard_noise, head.image_index, head.x, head.y, head.scale * head.visual_scale, head.scale * head.visual_scale, 0, c_white, 1);
	}
}

// modifiers
if alarm[0] <= 130 && start
{
	if array_length(modifiers) == 1
		modif_t = 1;
	else
		modif_t = floor(lerp(0, array_length(modifiers), clamp(1 - ((alarm[0] - 60) / (130 - 60)), 0, 1)));
}

if modif_con < modif_t
{
	modif_con = modif_t;
	sound_play_centered(sfx_killingblow);
	modif_shake = 3;
	
	if modif_t >= array_length(modifiers) && array_length(modifiers) > 5
		sound_play_centered("event:/modded/sfx/enemyscream");
}

#region ALIGN

// 0 TOP RIGHT
// 1 BOTTOM RIGHT
// 2 BOTTOM LEFT
// 3 TOP LEFT

var align = 2;
if titlecard_sprite == spr_titlecards switch titlecard_index
{
	case 0: align = 2; break; // JOHN GUTTER
	case 1: align = 2; break; // MEDIEVAL
	case 2: align = 1; break; // RUIN
	case 3: align = 1; break; // DUNGEON
	
	case 4: align = 2; break; // DESERT
	case 5: align = 2; break; // GRAVEYARD
	case 6: align = 1; break; // FARM
	case 7: align = 1; break; // SALOON
	
	case 8: align = 1; break; // PLAGE
	case 9: align = 2; break; // FOREST
	case 10: align = 1; break; // SPACE
	case 11: align = 2; break; // GOLF
	
	case 12: align = 0; break; // STREET
	case 13: align = 1; break; // SEWER
	
	case 14: align = 2; break; // WAR
	case 15: align = 2; break; // CTOP
	
	case 16: align = 2; break; // FACTORY
	case 17: align = 3; break; // FREEZER
	
	case 18: align = 1; break; // CHATEAU
	case 19: align = 1; break; // KIDSPARTY
}

if titlecard_sprite == spr_titlecardsecret
	align = 2;

if titlecard_sprite == spr_titlecards_new switch titlecard_index
{
	case 0: align = 2; break; // DRAGONLAIR
	case 1: align = 3; break; // STRONGCOLD
	case 2: align = 2; break; // PINBALL
	case 3: align = 1; break; // MANSION
	case 4: align = 3; break; // MIDWAY
	case 5: align = 0; break; // GRINCH
	case 6: align = 2; break; // SKY
	case 7: align = 2; break; // BOILER
	case 8: align = 3; break; // SNICKCHALLENGE
	case 9: align = 2; break; // TOP
	case 10: align = 2; break; // ETB
}

#endregion

var xx = 16, yy = 16;
for(var i = 0; i < modif_con; i++)
{
	var xdraw = xx, ydraw = yy;
	if i == modif_con - 1
	{
		xdraw += random_range(-modif_shake, modif_shake);
		ydraw += random_range(-modif_shake, modif_shake);
	}
	if align == 0 or align == 1
		xdraw = SCREEN_WIDTH - 32 - xdraw;
	if align == 1 or align == 2
		ydraw = SCREEN_HEIGHT - 32 - ydraw;
	
	draw_sprite(spr_modifier_icons, modifiers[i], xdraw, ydraw);
	
	xx += 38;
	if i % 5 == 4
	{
		xx = 16;
		yy += 38;
	}
}
modif_shake = Approach(modif_shake, 0, 0.2);

// fade
if !instance_exists(obj_fadeout)
	draw_set_alpha(fadealpha);
else
	draw_set_alpha(obj_fadeout.fadealpha);
draw_rectangle_color(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0, false);
draw_set_alpha(1);

toggle_alphafix(false);

