shader_set(global.Pal_Shader);
pal_swap_set(spr_noiseboss_palette, scr_isnoise(obj_player1) ? 1 : 2, false);
draw_self();
shader_reset();
