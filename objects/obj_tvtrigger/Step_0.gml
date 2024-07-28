if cyop
{
	if tv_default_condition()
	{
	    if !in_saveroom()
	    {
			if check_sugarychar()
				tv_spr = spr_tv_failsafeSP; // lmfao
	        prompt_array[0] = [text, special, tv_spr, scroll];
	        tv_push_prompt_array(prompt_array);
	        add_saveroom();
	        instance_destroy();
	    }
	}
}
else if (prompt_array != noone && prompt_condition != noone && prompt_condition())
{
	if !in_saveroom()
	{
		tv_push_prompt_array(prompt_array);
		add_saveroom();
		instance_destroy();
	}
}
