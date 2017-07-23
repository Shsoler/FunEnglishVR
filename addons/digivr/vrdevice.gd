extends Reference

# Public variables
const VERTICAL_ALIGNMENT_BOTTOM = 0
const VERTICAL_ALIGNMENT_CENTER = 1
const VERTICAL_ALIGNMENT_TOP = 2

const PRIMARY_BUTTON_NONE = 0
const PRIMARY_BUTTON_MAGNET = 1
const PRIMARY_BUTTON_TOUCH = 2
const PRIMARY_BUTTON_INDIRECT_TOUCH = 3

var search_dir = ""
var parameters = {
"left_eye_fov_angles": [0.0,0.0,0.0,0.0],
"right_eye_fov_angles": [0.0,0.0,0.0,0.0],
"model": "",
"vendor": "",
"screen_to_lens_distance": 0.0,
"inter_lens_distance": 0.0,
"tray_to_lenses_distance": 0.0,
"distortion_coefficients": [0.0]
}

func _get_property_list():
	return [
		{"name": "left_eye_fov_angles", "type": TYPE_REAL_ARRAY, "hint": PROPERTY_HINT_NONE, "hint_name": "Left Eye FOV array", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "right_eye_fov_angles", "type": TYPE_REAL_ARRAY, "hint": PROPERTY_HINT_NONE, "hint_name": "Right Eye FOV array", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "model", "type": TYPE_STRING, "hint": PROPERTY_HINT_NONE, "hint_name": "Device model", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "vendor", "type": TYPE_STRING, "hint": PROPERTY_HINT_NONE, "hint_name": "Device vendor", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "screen_to_lens_distance", "type": TYPE_REAL, "hint": PROPERTY_HINT_NONE, "hint_name": "Screen to lenses distance", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "inter_lens_distance", "type": TYPE_REAL, "hint": PROPERTY_HINT_NONE, "hint_name": "Inter-lenses distance", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "vertical_alignment", "type": TYPE_INT, "hint": PROPERTY_HINT_NONE, "hint_name": "Vertical alignment", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "primary_button", "type": TYPE_INT, "hint": PROPERTY_HINT_NONE, "hint_name": "Primary button", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "has_magnet", "type": TYPE_BOOL, "hint": PROPERTY_HINT_NONE, "hint_name": "Has magnet?", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "tray_to_lenses_distance", "type": TYPE_REAL, "hint": PROPERTY_HINT_NONE, "hint_name": "Tray to lenses distance", "usage": PROPERTY_USAGE_DEFAULT},
		{"name": "distortion_coefficients", "type": TYPE_REAL_ARRAY, "hint": PROPERTY_HINT_NONE, "hint_name": "Distortion coefficients", "usage": PROPERTY_USAGE_DEFAULT},
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
			return OK
		else:
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

func get_profile_parameters(name): #JSON format...
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

func get_projection_fov():
	return (parameters.left_eye_fov_angles[0] + parameters.left_eye_fov_angles[1]) / 2.0