extends Reference

# Public variables
var search_dir = ""
var parameters = {
	"size": Vector2(0.0,0.0),
	"dpi": 0,
	"metrics": Vector2(0.0,0.0)
}

func _get_property_list():
	return [
		{"name": "size", "type": TYPE_VECTOR2, "hint": PROPERTY_HINT_NONE, "hint_name": "Screen size in pixels", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "dpi", "type": TYPE_INT, "hint": PROPERTY_HINT_NONE, "hint_name": "Screen dpi", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "metrics", "type": TYPE_VECTOR2, "hint": PROPERTY_HINT_NONE, "hint_name": "Screen metrics in meters", "usage": PROPERTY_USAGE_DEFAULT},
	]

func _get(property):
	return parameters[property]

func _set(property, value):
	parameters[property] = value

func load_profile(name):
	var file = File.new()
		
	if file.open(search_dir + "/" + name, file.READ) == OK:
		if parameters.parse_json(file.get_as_text()) == OK:
			file.close()
			parameters.size = Vector2(parameters.size[0],parameters.size[1])
			parameters.metrics = Vector2(parameters.metrics[0],parameters.metrics[1])
			return OK
		else:
			print("ERRO")
			file.close()
			return ERR_PARSE_ERROR
	else:
		return ERR_FILE_NOT_FOUND

func get_available_profiles():
	var dir = Directory.new()
	var profiles = []
	
	if dir.open(search_dir) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if not dir.current_is_dir():
				profiles.append(file_name)
			file_name = dir.get_next()

	return profiles

func get_profile_parameters(name):
	var file = File.new()
	var profile_parameters = {}
		
	if file.open(search_dir + "/" + name, file.READ) == OK:
		if profile_parameters.parse_json(file.get_as_text()) == OK:
			file.close()
			return profile_parameters
		else:
			file.close()
			return null
	else:
		return null

func load_device_profile():
	parameters.size = OS.get_window_size()
	parameters.dpi = OS.get_screen_dpi()
	parameters.metrics = OS.get_window_size()
	
	parameters.metrics.x *= OS.get_screen_dpi() * 0.0254
	parameters.metrics.y *= OS.get_screen_dpi() * 0.0254

func get_pixels(meters):
	return (parameters.dpi * meters) / 0.0254

func get_meters(pixels):
	return pixels * OS.get_screen_dpi() * 0.0254