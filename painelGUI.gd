extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	pass
func _process(delta):
	get_node("propriedade").set_text(Globals.get("TIPO"))
	get_node("propriedade2").set_text(Globals.get("PROP"))
	get_node("pontos").set_text(str(Globals.get("pontos")))
	get_node("vidas").set_text(str(Globals.get("vidas")))
	get_node("tempo").set_text(str(Globals.get("tempo")))
	
