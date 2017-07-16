extends Spatial
var propriedade = "nenhuma"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func mudacor(cor):
	var material = FixedMaterial.new()
	var mesh = MeshInstance.new()
	mesh = get_node("Sphere").get_mesh()
	material.set_parameter(material.PARAM_EMISSION,cor)
	mesh.surface_set_material(0,material)
	get_node("Sphere").set_mesh(mesh)

func adicionarprop(valor):
	
	propriedade = valor