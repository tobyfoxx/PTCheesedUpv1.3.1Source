currentState = nextState;
if (currentState == GateState.RAISED)
	sprite_index = spr_sucrosegateRaised;
else if (currentState == GateState.LOWERED)
	sprite_index = spr_sucrosegateLowered;
