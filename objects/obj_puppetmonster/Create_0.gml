init_collision();
event_inherited();
monsterid = 2;
spr_dead = spr_monstertomato_dead;
spr_intro = spr_puppet_intro;
spr_introidle = spr_puppet_introidle;
state = states.robotidle;
inactivebuffer = 900;
snd = fmod_event_create_instance("event:/sfx/monsters/puppetfly");
xs = room_width / 2;
yy = -100;
substate = states.fall;
backgroundID = noone;