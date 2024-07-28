if (grabbedPlayer != noone)
{
    var xx = xstart
    var yy = ystart
    if (farBuffer >= 10)
    {
        xx += (random_range((-farBuffer), farBuffer) / 50)
        yy += (random_range((-farBuffer), farBuffer) / 50)
        draw_sprite(spr_flingfrogmadTire, image_index, xx, yy)
    }
    draw_sprite_ext(spr_flingfrogmad, image_index, xx, yy, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
}
else
    draw_sprite(spr_flingFrog, image_index, xstart, ystart)
if (grabbedPlayer != noone)
    draw_sprite(spr_flingfrog_handsmove, image_index, x, y)
else
{
    draw_sprite(spr_flingFrogGrab, candyindex, x, y)
    draw_sprite(spr_flingfrog_handsidle, image_index, x, y)
}

/*
if (global.debugmode == 1)
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true)
*/
