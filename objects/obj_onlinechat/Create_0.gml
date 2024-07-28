#macro CHAT_MAXLEN 64

curBlink = true;
isOpen = false;
inputText = "";
textList = ds_list_create();
textHistory = "";
storedText = "";

keyboard_string = "";
depth = -500;
alarm[1] = 60;
