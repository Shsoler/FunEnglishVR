tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("VRCamera", "Spatial", preload("vrcamera.gd"), preload("vrcamera.png"))
	add_custom_type("VRDevice", "Reference", preload("vrdevice.gd"), preload("vrcamera.png"))
	add_custom_type("VRScreen", "Reference", preload("vrscreen.gd"), preload("vrcamera.png"))	
	add_custom_type("VRHeadTracker", "Reference", preload("vrheadtracker.gd"), preload("vrcamera.png"))	

func _exit_tree():
	remove_custom_type("VRCamera")
	remove_custom_type("VRDevice")
	remove_custom_type("VRScreen")
	remove_custom_type("VRHeadTracker")