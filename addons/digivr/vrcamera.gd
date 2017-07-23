extends Spatial

# Constants
const EYE_LEFT = 0
const EYE_RIGHT = 1

const MODE_2D = 0
const MODE_3D = 1

const RETICLE_STATE_ACTIVE = 0
const RETICLE_STATE_DISABLED = 1
const RETICLE_STATE_HOVER = 2

const RETICLE_TYPE_ROUND = 0
const RETICLE_TYPE_POINT = 1

# Public variables
var screen = preload("vrscreen.gd").new()
var device = preload("vrdevice.gd").new()
var head_tracker = preload("vrheadtracker.gd").new()
var vr_camera_scene = preload("res://addons/digivr/vrcamera.tscn").instance()

# Exported variables
export(bool) var active = false setget _set_active
export (NodePath) var copy_object_transform
export(int, "2d", "3d") var mode = MODE_3D setget _set_mode
export(String, DIR) var devices_directory setget _set_devices_directory
export(String, DIR) var screens_directory setget _set_screens_directory
export(String) var device_name = "Default" setget _set_device_name
export(String) var screen_name = "Default" setget _set_screen_name
export(float) var camera_fov = 60.0 setget _set_camera_fov
export(float) var camera_znear = 0.1 setget _set_camera_znear
export(float) var camera_zfar = 100.0 setget _set_camera_zfar
export(Environment) var camera_environment setget _set_camera_environment
export(NodePath) var flat_viewport
export(bool) var use_head_tracking = false setget _set_use_head_tracking
export(bool) var use_object_transform = false

export(Color) var reticle_color = Color(0.0,0.0,0.0) setget _set_reticle_color
export(Texture) var reticle_texture_round_active
export(Texture) var reticle_texture_round_disabled
export(Texture) var reticle_texture_round_hover
export(Texture) var reticle_texture_point_active
export(Texture) var reticle_texture_point_disabled
export(Texture) var reticle_texture_point_hover
export(int, "Active", "Disabled", "Hover") var reticle_state = RETICLE_STATE_ACTIVE setget _set_reticle_state
export(int, "Round", "Point") var reticle_type = RETICLE_TYPE_POINT setget _set_reticle_type
export(int) var reticle_size = 40.0 setget _set_reticle_size

func _ready():
	# Add scene
	self.add_child(vr_camera_scene)
	
	# Fill all device and screen profiles
	var device_name_combo = get_node(@"VRCamera/SettingsPanel/Settings/SettingsCenter/SettingsGrid/DeviceNameCombo")
	var screen_name_combo = get_node(@"VRCamera/SettingsPanel/Settings/SettingsCenter/SettingsGrid/ScreenNameCombo")
	var index = 0
	
	device_name_combo.clear()	
	
	index = 0
	
	for profile in device.get_available_profiles():
		device_name_combo.add_item(profile, index)
		index += 1
	
	screen_name_combo.clear()
	screen_name_combo.add_item("Get screen profile", 0)
	
	index = 1
	
	for profile in screen.get_available_profiles():
		screen_name_combo.add_item(profile, index)
		index += 1
	
	# Load device profile
	self.devices_directory = devices_directory
	self.screens_directory = screens_directory
	self.device_name = device_name
	self.screen_name = screen_name
	self.use_head_tracking = use_head_tracking	
	self.mode = mode
	self.reticle_color = reticle_color
	self.reticle_state = reticle_state
	self.reticle_type = reticle_type
	self.reticle_size = reticle_size
	self.camera_fov = camera_fov
	self.camera_znear = camera_znear
	self.camera_zfar = camera_zfar	
	self.active = active	
	
	_on_change_resolution()
	
	get_node(@"VRCamera/HUD/SettingsButton").connect("pressed", self, "_on_settings_pressed")
	
	get_node(@"VRCamera/SettingsPanel/Settings/OkButton").connect("pressed", self, "_on_settings_ok_pressed")
	get_node(@"VRCamera/SettingsPanel/Settings/CancelButton").connect("pressed", self, "_on_settings_cancel_pressed")
	
	get_tree().get_root().connect("size_changed", self, "_on_change_resolution")
	
	self.set_process(true)

func _process(delta):	
	if active == true:
		if head_tracker.is_tracking == true && use_head_tracking == true:
			head_tracker._update(delta)

		_update_transform_data()

		if copy_object_transform != "":
			if use_object_transform == true:
				self.set_transform(get_node(copy_object_transform).get_transform())
			else:
				get_node(copy_object_transform).set_transform(self.get_transform())
		
		_update_camera_transform()

func get_eye_viewport(vr_eye):
	if vr_eye == EYE_LEFT:
		return get_node(@"VRCamera/LeftEyeViewport")
	else:
		return get_node(@"VRCamera/RightEyeViewport")

func get_eye_flat_viewport(vr_eye):
	if vr_eye == EYE_LEFT:
		return get_node(@"VRCamera/LeftEyeFlatViewport")
	else:
		return get_node(@"VRCamera/RightEyeFlatViewport")

func get_eye_camera(vr_eye):
	if vr_eye == EYE_LEFT:
		return get_node(@"VRCamera/LeftEyeViewport/LeftEyeCamera")
	else:
		return get_node(@"VRCamera/RightEyeViewport/RightEyeCamera")

func get_eye_reticle(vr_eye):
	if vr_eye == EYE_LEFT:
		return get_node(@"VRCamera/HUD/LeftEyeReticle")
	else:
		return get_node(@"VRCamera/HUD/RightEyeReticle")

func _set_active(vr_active):
	active = vr_active
	
	if self.is_inside_tree() == false:
		return	
	
	if copy_object_transform != "":
		head_tracker.reset(get_node(copy_object_transform).get_rotation())
	
	if active == true:
		head_tracker.is_tracking = true
		get_eye_flat_viewport(EYE_LEFT).set_hidden(false)
		get_eye_flat_viewport(EYE_RIGHT).set_hidden(false)
		get_eye_reticle(EYE_LEFT).set_hidden(false)
		get_eye_reticle(EYE_RIGHT).set_hidden(false)
		get_node(@"VRCamera/HUD/SettingsButton").set_hidden(false)
		get_node(@"VRCamera/HUD/EyeSeparator").set_hidden(false)		
	else:
		head_tracker.is_tracking = false
		get_eye_flat_viewport(EYE_LEFT).set_hidden(true)
		get_eye_flat_viewport(EYE_RIGHT).set_hidden(true)
		get_eye_reticle(EYE_LEFT).set_hidden(true)
		get_eye_reticle(EYE_RIGHT).set_hidden(true)
		get_node(@"VRCamera/HUD/SettingsButton").set_hidden(true)
		get_node(@"VRCamera/HUD/EyeSeparator").set_hidden(true)

func _set_mode(vr_mode):
	mode = vr_mode
	
	if self.is_inside_tree() == false:
		return
	
	if mode == MODE_2D:
		get_eye_flat_viewport(EYE_LEFT).set_viewport_path("../../" + flat_viewport)
		get_eye_flat_viewport(EYE_RIGHT).set_viewport_path("../../" + flat_viewport)
	else:
		get_eye_flat_viewport(EYE_LEFT).set_viewport_path(get_eye_viewport(EYE_LEFT).get_path())
		get_eye_flat_viewport(EYE_RIGHT).set_viewport_path(get_eye_viewport(EYE_RIGHT).get_path())

func _set_devices_directory(vr_devices_directory):
	devices_directory = vr_devices_directory
	device.search_dir = devices_directory
	

func _set_screens_directory(vr_screens_directory):
	screens_directory = vr_screens_directory
	screen.search_dir = screens_directory

func _set_device_name(vr_device_name):
	device_name = vr_device_name	

	if self.is_inside_tree() == false:
		return
	
	var device_name_combo = get_node(@"VRCamera/SettingsPanel/Settings/SettingsCenter/SettingsGrid/DeviceNameCombo")
	
	if device_name_combo.get_item_text(device_name_combo.get_selected()) != device_name:				
		var index = 0
		for i in range(0, device_name_combo.get_item_count()):
			if device_name_combo.get_item_text(i) == device_name:
				device_name_combo.select(i)
				break
	
	if device.load_profile(device_name) != OK:
		print("<VrCamera> ERROR: Can't load device profile")

	_on_change_resolution()

func _set_screen_name(vr_screen_name):
	screen_name = vr_screen_name
		
	if self.is_inside_tree() == false:
		return
		
	var screen_name_combo = get_node(@"VRCamera/SettingsPanel/Settings/SettingsCenter/SettingsGrid/ScreenNameCombo")
	
	if screen_name_combo.get_item_text(screen_name_combo.get_selected()) != screen_name:		
		if screen_name == "":
			screen_name_combo.select(0)
		else:
			var index = 0
			for i in range(0, screen_name_combo.get_item_count()):
				if screen_name_combo.get_item_text(i) == screen_name:
					screen_name_combo.select(i)
					break	
	
	if screen_name != "":
		if screen.load_profile(screen_name) != OK:
			print("<VrCamera> ERROR: Can't load screen profile")
	else:
		screen.load_device_profile()
	
	_on_change_resolution()
	
func _set_camera_fov(vr_camera_fov):
	camera_fov = vr_camera_fov
	
	if self.is_inside_tree() == false:
		return
	
	_update_camera()

func _set_camera_znear(vr_camera_znear):
	camera_znear = vr_camera_znear
	
	if self.is_inside_tree() == false:
		return
	
	_update_camera()

func _set_camera_zfar(vr_camera_zfar):	
	camera_zfar = vr_camera_zfar
	
	if self.is_inside_tree() == false:
		return
	
	_update_camera()

func _set_camera_environment(vr_camera_environment):
	camera_environment = vr_camera_environment
	
	if self.is_inside_tree() == false:
		return
		
	_update_camera()

func _set_use_head_tracking(vr_use_head_tracking):
	use_head_tracking = vr_use_head_tracking
	
	if self.is_inside_tree() == false:
		return
	
	head_tracker.is_tracking = use_head_tracking

	if copy_object_transform != "":
		head_tracker.reset(get_node(copy_object_transform).get_rotation())

func _set_reticle_color(vr_reticle_color):
	reticle_color = vr_reticle_color
	
	if self.is_inside_tree() == false:
		return
	
	get_eye_reticle(EYE_LEFT).set_modulate(reticle_color)
	get_eye_reticle(EYE_RIGHT).set_modulate(reticle_color)

func _set_reticle_state(vr_reticle_state):
	reticle_state = vr_reticle_state
	
	if self.is_inside_tree() == false:
		return
	
	_update_reticle()

func _set_reticle_type(vr_reticle_type):
	reticle_type = vr_reticle_type
	
	if self.is_inside_tree() == false:
		return
	
	_update_reticle()

func _set_reticle_size(vr_reticle_size):
	reticle_size = vr_reticle_size
	
	if self.is_inside_tree() == false:
		return

	_update_reticle()

func _update_reticle():
	# Set reticle sizes
	get_eye_reticle(EYE_LEFT).set_size(Vector2(reticle_size, reticle_size))
	get_eye_reticle(EYE_RIGHT).set_size(Vector2(reticle_size, reticle_size))
	
	if get_eye_reticle(EYE_RIGHT).get_texture():
		get_eye_reticle(EYE_LEFT).set_scale(Vector2(reticle_size / get_eye_reticle(EYE_LEFT).get_texture().get_size().x, reticle_size / get_eye_reticle(EYE_LEFT).get_texture().get_size().y))
		get_eye_reticle(EYE_RIGHT).set_scale(Vector2(reticle_size / get_eye_reticle(EYE_LEFT).get_texture().get_size().x, reticle_size / get_eye_reticle(EYE_LEFT).get_texture().get_size().y))

	# Set reticle types
	if reticle_type == RETICLE_TYPE_POINT:
		if reticle_state == RETICLE_STATE_ACTIVE:
			get_eye_reticle(EYE_LEFT).set_texture(reticle_texture_point_active)
			get_eye_reticle(EYE_RIGHT).set_texture(reticle_texture_point_active)
		elif reticle_state == RETICLE_STATE_DISABLED:
			get_eye_reticle(EYE_LEFT).set_texture(reticle_texture_point_disabled)
			get_eye_reticle(EYE_RIGHT).set_texture(reticle_texture_point_disabled)
		else:
			get_eye_reticle(EYE_LEFT).set_texture(reticle_texture_point_hover)
			get_eye_reticle(EYE_RIGHT).set_texture(reticle_texture_point_hover)
	else:
		if reticle_state == RETICLE_STATE_ACTIVE:
			get_eye_reticle(EYE_LEFT).set_texture(reticle_texture_round_active)
			get_eye_reticle(EYE_RIGHT).set_texture(reticle_texture_round_active)
		elif reticle_state == RETICLE_STATE_DISABLED:
			get_eye_reticle(EYE_LEFT).set_texture(reticle_texture_round_disabled)
			get_eye_reticle(EYE_RIGHT).set_texture(reticle_texture_round_disabled)
		else:
			get_eye_reticle(EYE_LEFT).set_texture(reticle_texture_round_hover)
			get_eye_reticle(EYE_RIGHT).set_texture(reticle_texture_round_hover)

func _update_camera():
	get_eye_camera(EYE_LEFT).set_perspective(camera_fov, camera_znear, camera_zfar)
	get_eye_camera(EYE_RIGHT).set_perspective(camera_fov, camera_znear, camera_zfar)
	get_eye_camera(EYE_LEFT).set_environment(camera_environment)
	get_eye_camera(EYE_RIGHT).set_environment(camera_environment)

func _on_change_resolution():
	# Set viewports correct sizes and positions	
	get_eye_viewport(EYE_LEFT).set_rect(Rect2(0.0,0.0,screen.get("size").x / 2.0, screen.get("size").y))
	get_eye_viewport(EYE_RIGHT).set_rect(Rect2(0.0,0.0,screen.get("size").x / 2.0, screen.get("size").y))

	if flat_viewport != "":
		get_node(flat_viewport).set_rect(Rect2(0.0,0.0,screen.get("size").x / 2.0,screen.get("size").y))

	get_eye_flat_viewport(EYE_LEFT).set_offset(Vector2(0.0,0.0))
	get_eye_flat_viewport(EYE_RIGHT).set_offset(Vector2(screen.get("size").x / 2.0, 0.0))		
	
	# Set reticles positions
	var y_pos = 0.0
	
	if device.vertical_alignment == device.VERTICAL_ALIGNMENT_CENTER:
		y_pos = (screen.get("size").y / 2.0) - (get_eye_reticle(EYE_LEFT).get_size().y / 2)
	elif device.vertical_alignment == device.VERTICAL_ALIGNMENT_TOP:
		y_pos = screen.get_pixels(device.get("tray_to_lenses_distance")) - (get_eye_reticle(EYE_LEFT).get_size().y / 2)
	elif device.vertical_alignment == device.VERTICAL_ALIGNMENT_BOTTOM:
		y_pos = (screen.get("size").y - screen.get_pixels(device.get("tray_to_lenses_distance"))) - (get_eye_reticle(EYE_LEFT).get_size().y / 2)

	get_eye_reticle(EYE_LEFT).set_pos(Vector2((screen.get("size").x / 2.0) - (reticle_size / 2) - screen.get_pixels(device.get("inter_lens_distance") / 2.0),y_pos))
	get_eye_reticle(EYE_RIGHT).set_pos(Vector2((screen.get("size").x / 2.0) - (reticle_size / 2) + screen.get_pixels(device.get("inter_lens_distance") / 2.0),y_pos))

func _on_settings_ok_pressed():
	var device_name_combo = get_node(@"VRCamera/SettingsPanel/Settings/SettingsCenter/SettingsGrid/DeviceNameCombo")
	var screen_name_combo = get_node(@"VRCamera/SettingsPanel/Settings/SettingsCenter/SettingsGrid/ScreenNameCombo")
	
	if device_name_combo.get_selected_ID() == 0:
		self.device_name = "Default"
	else:
		self.device_name = device_name_combo.get_item_text(device_name_combo.get_selected())
		
	if screen_name_combo.get_selected_ID() == 0:
		self.screen_name = ""
	else:
		self.screen_name = screen_name_combo.get_item_text(screen_name_combo.get_selected())
	
	get_node(@"VRCamera/HUD/SettingsButton").set_disabled(false)
	get_node(@"VRCamera/SettingsPanel/Settings").set_hidden(true)

func _on_settings_cancel_pressed():
	self.device_name = device_name
	self.screen_name = screen_name
	
	get_node(@"VRCamera/HUD/SettingsButton").set_disabled(false)
	get_node(@"VRCamera/SettingsPanel/Settings").set_hidden(true)	

func _on_settings_pressed():
	get_node(@"VRCamera/HUD/SettingsButton").set_disabled(true)
	get_node(@"VRCamera/SettingsPanel/Settings").set_hidden(false)

func _update_transform_data():
	var object = self
	
	if copy_object_transform != "" &&  use_object_transform == true:
		object = get_node(copy_object_transform)
	
	object.global_rotate(Vector3(0.0,1.0,0.0),head_tracker.orientation_difference.y)
	object.rotate_x(-head_tracker.orientation_difference.x)

func _update_camera_transform():
	get_eye_camera(EYE_LEFT).set_transform(self.get_transform())
	get_eye_camera(EYE_LEFT).translate(Vector3(device.inter_lens_distance / 2.0, 0.0, 0.0))
	
	get_eye_camera(EYE_RIGHT).set_transform(self.get_transform())
	get_eye_camera(EYE_RIGHT).translate(Vector3(-(device.inter_lens_distance / 2.0), 0.0, 0.0))