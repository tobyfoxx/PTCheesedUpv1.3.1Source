live_auto_call;

// sync
character = online_characters.peppino;
username = "";
state = states.normal;

spr_palette = spr_peppalette;
pattern = noone;
paletteselect = 0;
color_array = [1, 2];
hat = -1;
pet = -1;
laps = 0;

// stuff
depth = -7;
mask_index = spr_player_mask;
image_speed = 0.35;
prevstate = state;

hsp = 0;
vsp = 0;
grounded = true;

timer = 1;
sprite_prev = sprite_index;

afterimage_time = 0;
breakdance_speed = 0;
flash = 0;

// sounds
scr_online_swapsounds(character, true);
