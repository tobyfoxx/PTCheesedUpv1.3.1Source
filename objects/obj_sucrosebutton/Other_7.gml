if (currentState = ButtonState.PRESSING)
{
	currentState = ButtonState.PRESSED;
	sprite_index = spr_Pressed;
}
else if (currentState = ButtonState.REVERTING)
{
	currentState = ButtonState.RELEASED;
	sprite_index = spr_Released;
}
