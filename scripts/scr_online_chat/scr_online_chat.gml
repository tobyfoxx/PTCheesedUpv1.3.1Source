function scr_chat_add(text)
{
	with obj_onlinechat
		ds_list_add(textList, text);
}
