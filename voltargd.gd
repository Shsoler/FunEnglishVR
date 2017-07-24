extends KinematicBody
var acao = "voltar"
var cena = "res://Menu.tscn"


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func sair():
	get_tree().change_scene("res://GameOVer.tscn")
