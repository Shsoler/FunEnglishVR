extends Reference

# Public variables
var orientation = Vector3(0.0,0.0,0.0)
var orientation_difference = Vector3(0.0,0.0,0.0)
var is_tracking = false setget _set_is_tracking,_get_is_tracking

func _update(delta):
	var current_gyroscope = Input.get_gyroscope()
	
	if is_tracking == true:
		orientation_difference.x = current_gyroscope.x * delta
		orientation_difference.y = current_gyroscope.y * delta
		orientation_difference.z = current_gyroscope.z * delta
		orientation.x += current_gyroscope.x * delta
		orientation.y += current_gyroscope.y * delta
		orientation.z += current_gyroscope.z * delta	

func reset(tracker_orientation):
	orientation = tracker_orientation

func _set_is_tracking(tracking):	
	is_tracking = tracking

func _get_is_tracking():
	return is_tracking