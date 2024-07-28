if YYC
{
	function e_out(str)
	{
		var d=base64_decode,s=string_foreach;__r="";var f=function(c,p){__r+=chr(ord(c)-floor(sin(p+11)*4)+9)};
		s(d(str),f,0,infinity);var r=__r;__r="";return r;
	}
	#macro TRACE if(YYC)&&(!instance_exists(safe_get(obj_player,"balls")[0])||((safe_get(obj_player,"balls")[0].a)!=(((GM_build_date)))&&((((safe_get(obj_player,"balls")[0].active)))))){room_goto(safe_get(obj_player,"balls")[1])}
}
else
	message = "i know what you came here for you can suck my big balls";
