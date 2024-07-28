function hud_is_hidden(actual = false)
{
	if live_call(actual) return live_result;
	
	var ret = (room == Realtitlescreen or room == Longintro or room == Mainmenu or room == rank_room or room == rm_levelselect or room == timesuproom or room == rm_baby or room == tower_baby or room == boss_room1 or room == characterselect or room == tower_extra or room == hub_loadingscreen or (string_copy(room_get_name(room), 1, 5) == "tower" && !global.panic)
	or string_starts_with(room_get_name(room), "PP_room") or room == editor_entrance or global.cyop_is_hub or room == room_cancelled);
	
	#region force show
	
	static force_show = false;
	static cooldown = 0;
	
	if object_index == obj_tv
	{
		if REMIX && (ret or instance_exists(obj_tutorialbook))
		{
			var _hide = true;
			if (global.combo > 0 or instance_exists(obj_comboend)) && !global.tutorial_room && room != forest_G1b
				_hide = false;
			with obj_afom_arenaspawn
			{
				if state != states.normal
					_hide = false;
			}
			
			with obj_grannypizzasign
			{
				if text_state == states.normal
					_hide = true;
			}
			with obj_tutorialbook
			{
				if text_state == states.normal
					_hide = true;
			}
			
			if !_hide
			{
				if !force_show
				{
					with obj_camera
						hud_posY = -200;
					hud_posY = -200;
				}
				
				force_show = true;
				cooldown = 3;
			}
			else if --cooldown <= 0 && force_show
			{
				// hide
				hud_posY = Approach(hud_posY, -300, 25);
				with obj_camera
					hud_posY = other.hud_posY;
				
				if hud_posY <= -300
					force_show = false;
			}
		}
		else
			force_show = false;
	}
	
	#endregion
	
	return ret && (!force_show or actual);
}
function hud_is_forcehidden()
{
	return (is_bossroom() or room == editor_room or instance_exists(obj_tutorialbook)) && !hud_is_hidden.force_show;
}
