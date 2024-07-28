function scr_solid_player(_x, _y)
{
	var old_x = x;
	var old_y = y;
	
	x = _x;
	y = _y;
	
	if flip < 0
		y = old_y - (_y - old_y);
	
	// walls
	ds_list_clear(global.instancelist);
	var num = instance_place_list(x, y, obj_solid, global.instancelist, false);
	
	var _collided = false;
	for (var i = 0; i < num; i++)
	{
		var b = ds_list_find_value(global.instancelist, i);
		if (instance_exists(b))
		{
			switch (b.object_index)
			{
				case obj_ghostwall:
					if (state != states.ghost)
						_collided = true;
					break;
				case obj_mach3solid:
					if (state != states.mach3 && (state != states.machslide || sprite_index != spr_mach3boost) && (state != states.chainsaw || tauntstoredstate != states.mach3) && (state != states.rupertjump && state != states.rupertslide))
						_collided = true;
					break;
				case obj_metalblock:
				if (state != states.rupertjump && state != states.rupertslide)
					_collided = true;
					break;
				default:
					_collided = true;
			}
		}
		if (_collided)
			break;
	}
	ds_list_clear(global.instancelist);
	
	if (_collided)
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	// platforms
	if state != states.ladder && state != states.ratmountladder && place_meeting(x, y, obj_platform)
	{
		var num = instance_place_list(x, y, obj_platform, global.instancelist, false);
		var _collided = false;
		for (var i = 0; i < num; i++)
		{
			var b = ds_list_find_value(global.instancelist, i);
			if (b.image_yscale > 0 && y > old_y) or (b.image_yscale < 0 && y < old_y)
			{
				if (!place_meeting(x, old_y, b) && place_meeting(x, y, b))
				{
	                if (b.object_index == obj_cottonplatform_tiled)
                        _collided = (state == states.cotton || state == states.cottonroll);
					else
						_collided = true;
				}
			}
		}
		ds_list_clear(global.instancelist);
		
		if (_collided)
		{
			x = old_x;
			y = old_y;
			return true;
		}
	}
	
	// platform slopes
	if vsp >= 0 && state != states.Sjump && state != states.ladder && state != states.ratmountladder && place_meeting(x, y, obj_slope_platform)
	{
		var num = instance_place_list(x, y, obj_slope_platform, global.instancelist, false);
		var _collided = false;
	
		for (i = 0; i < num; i++)
		{
			b = ds_list_find_value(global.instancelist, i);
			if check_slope_platform(b, old_y)
				_collided = true;
		}
		ds_list_clear(global.instancelist);
	
		if (_collided)
		{
			x = old_x;
			y = old_y;
			return true;
		}
	}
	
	// grindrails
	if (y > old_y && state == states.grind && !place_meeting(x, old_y, obj_grindrail) && place_meeting(x, y, obj_grindrail))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	// slopes
	if (inside_slope(obj_slope))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	if (check_concave_slope_player(obj_concaveslope))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	// grindrail slopes
	if (state == states.grind && inside_slope(obj_grindrailslope))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	x = old_x;
	y = old_y;
	return false;
}
function check_slope_pos(new_x, new_y, slope_obj = obj_slope)
{
	var xx = x, yy = y;
	x = new_x;
	y = new_y;
	var ret = inside_slope(slope_obj);
	x = xx;
	y = yy;
	return ret;
}

function check_concave_slope_player(concave_slope_object)
{
	var slope = instance_place(x, y, concave_slope_object);
	if (slope)
	{
		with (slope)
		{
			
			var slope_start = 0;
			var slope_end = 0;
			
			
			var object_side = 0; // Object side to compare to
			var slope_max_side = 0; // Side where the max is
			var slope_min_side = 0; // Side where the min is
			
			if (image_xscale > 0)
			{
				object_side = other.bbox_right + 1;
				slope_max_side = bbox_right;
				slope_min_side = bbox_left;
				//slope_start = bbox_bottom;
				//slope_end = bbox_top;
			}
			else
			{
				object_side = other.bbox_left;
				slope_max_side = bbox_left;
				slope_min_side = bbox_right;
			}
			//var m = (sign(image_xscale) * (bbox_bottom - bbox_top)) / (bbox_right - bbox_left);
			//slope = slope_start - round(m * (object_side - bbox_left));
			
		
			//Gonna have to use some trig here to build a height map
			var radius_x = 32 * image_xscale;
			var radius_y = 32 * image_yscale;
			
			if (point_in_ellipse(object_side, other.bbox_bottom, slope.x, slope.y, radius_x, radius_y) > 1)
				return true;
		}
	}
	return false;
}

function point_in_ellipse(_px, _py, _x, _y, _x_axis, _y_axis)
{
	return (power(_px - _x, 2) / power(_x_axis, 2)) + (power(_py - _y, 2) / power(_y_axis, 2));
}
