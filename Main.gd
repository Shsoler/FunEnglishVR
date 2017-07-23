extends Spatial

var vida = 3
var pontos = 0
var fase = load("res://WorldEnvironment.tscn").instance()
var ref
func _ready():
	Globals.set("gamemode", true)
	Globals.set("vidas",3)
	Globals.set("pontos",0)
	Globals.set("next",false)
	self.add_child(fase)
	pass
	set_process_input(true)
	set_process(true)
#func _process(delta):
#	if(Globals.get("next")):
#		fase.queue_free()
#	print(Globals.get("next"))