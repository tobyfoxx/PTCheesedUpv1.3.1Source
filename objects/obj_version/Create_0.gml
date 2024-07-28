depth = -500;

ver = GM_version;
ver = string_copy(ver, 3, string_length(ver));

if DEBUG
	ver = "TEST";
else if string_starts_with(GM_version, "0.")
	ver = $"B{ver}";
else if string_starts_with(GM_version, "2.")
	ver = $"P{ver}";
else
	ver = $"V{ver}";

if string_ends_with(ver, ".0")
	ver = string_delete(ver, string_length(ver) - 2, 2);
