extends TestCube

var view_sensitivity = 0.3;

const walk_speed = 5;
const jump_speed = 3;
const max_accel = 0.02;
const air_accel = 0.1;

func _input(ie):
    
	set_process(true)
	if ie.type == InputEvent.MOUSE_MOTION:
		var yaw = rad2deg(get_node(".").get_rotation().y);
		var pitch = rad2deg(get_node("Camera").get_rotation().x);
		
		yaw = fmod(yaw - ie.relative_x * view_sensitivity, 360);
		pitch = max(min(pitch - ie.relative_y * view_sensitivity, 90), -90);
		
		get_node(".").set_rotation(Vector3(0, deg2rad(yaw), 0));
		get_node("Camera").set_rotation(Vector3(deg2rad(pitch), 0, 0));
	if Input.is_action_pressed("mv_up"):
		var pos_atual = self.get_translation()+Vector3(0,0,-1)
		self.set_translation(pos_atual)
	if Input.is_action_pressed("mv_down"):
		var pos_atual = self.get_translation()+Vector3(0,0,1)
		self.set_translation(pos_atual)
	if Input.is_action_pressed("mv_left"):
		var pos_atual = self.get_translation()+Vector3(-1,0,0)
		self.set_translation(pos_atual)
	if Input.is_action_pressed("mv_right"):
		var pos_atual = self.get_translation()+Vector3(1,0,0)
		self.set_translation(pos_atual)
func _ready():
	set_process_input(true);

func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
var temporizador = 0.0
func _process(delta):
	var objetocolisao
	temporizador += delta
	if(get_node("Camera/RayCast").is_colliding()):
		objetocolisao = get_node("Camera/RayCast").get_collider()
		get_node("Camera/Label 2").set_text(objetocolisao.propriedade)
		if objetocolisao.propriedade == get_node("Camera/Label").get_text():
			get_node("Camera/TextureProgress").set_value(get_node("Camera/TextureProgress").get_value()-temporizador)
			if temporizador >= 1.0:
				temporizador = 0
			if get_node("Camera/TextureProgress").get_value() == 0:
				objetocolisao.hide()
	else:
		get_node("Camera/TextureProgress").set_value(60)
		