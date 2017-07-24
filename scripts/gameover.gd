extends WorldEnvironment

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("Area/Quad").get_material_override().set_texture(FixedMaterial.PARAM_DIFFUSE, get_node("Viewport").get_render_target_texture())
	Globals.set("gamemode",false)
	pass
