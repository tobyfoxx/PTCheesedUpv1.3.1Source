global.longintro = true;
if YYC
{
	if !variable_global_exists("collect2")
		instance_create(0, 0, obj_softlockcrash);
}

global.swapmode = false; // disclaimer uses input
tdp_text_init();

global.holiday = holiday.none;
var date = date_current_datetime();
var month = date_get_month(date);
var day = date_get_day(date);
if month == 10 || (month == 11 && day <= 14)
    global.holiday = holiday.halloween;
