function scr_transformationcheck()
{
	// If not in a transformation
	if state == states.morthook && character == "V"
		return true;
	return !array_contains(transformation, state) or (state == states.actor or state == states.tube);
}
