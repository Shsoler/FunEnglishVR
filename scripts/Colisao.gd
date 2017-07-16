extends StaticBody

var propriedade = "errado"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func mudacor(cor):
	var material = FixedMaterial.new()
	material.set_parameter(material.PARAM_DIFFUSE,cor)
	get_node("TestCube").set_material_override(material)

func adicionarprop(valor):
	propriedade = valor