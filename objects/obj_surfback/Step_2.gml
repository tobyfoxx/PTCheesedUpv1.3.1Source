if !instance_exists(obj_player1)
	exit;

var target = obj_player1.id;
image_speed = obj_player1.image_speed;
if global.swapmode && scr_ispeppino(obj_player1)
	target = obj_swapmodefollow.id;
x = target.x;
y = target.y;
if target == obj_player1.id
{
	image_xscale = (target.xscale * target.scale_xs);
	image_yscale = (target.yscale * target.scale_ys);
}
else
{
	image_xscale = target.image_xscale;
	image_yscale = target.image_yscale;
}
visible = target.visible;
image_alpha = target.image_alpha;
image_blend = target.image_blend;
depth = 0;
if scr_ispeppino(obj_player1) && !global.swapmode
	instance_destroy();
if ((target == obj_player1.id && (obj_player1.state == states.slipnslide || obj_player1.state == states.trashjump)) || room == rank_room)
	visible = false;
visible = false;
