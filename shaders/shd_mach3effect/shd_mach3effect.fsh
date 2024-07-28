varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 color1;
uniform vec3 color2;
uniform int raw;

void main()
{
    vec4 color = vec4(texture2D(gm_BaseTexture, v_vTexcoord));
	if (raw == 0)
	{
		if (distance(color.rgb, vec3(0, 0, 0)) <= 0.025)
			color.rgb = color2;
		else
			color.rgb = color1;
	}
	else
	{
		// REMIX off afterimage fix
		vec3 cyan = vec3(0, 1, 1);
		vec3 dark_cyan = vec3(0, 174 / 255, 240 / 255);
		
		vec3 yellow = vec3(1, 1, 64 / 255);
		vec3 dark_yellow = vec3(145 / 255, 143 / 255, 43 / 255);
		
		if (distance(color.rgb, cyan) <= 0.025)
			color.rgb = yellow;
		if (distance(color.rgb, dark_cyan) <= 0.025)
			color.rgb = dark_yellow;
	}
	gl_FragColor = v_vColour * color;
}
