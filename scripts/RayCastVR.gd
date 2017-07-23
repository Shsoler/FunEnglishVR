extends RayCast

var vidasrestantes = 3
var wait = false

func _ready():
	self.set_transform((get_node(".").get_transform()))
	if !Globals.get("gamemode"):
		get_node("../HUD/hl1").hide()
	set_process(true)
	pass

var temporizador = 0.0
func _process(delta):
	if Globals.get("gamemode"):
		playmode()
	temporizador += delta
	if temporizador >= 1.0:
		temporizador = 0.0
	if self.is_colliding():
		get_node("../HUD/RightEyeReticle").set_value(get_node("../HUD/RightEyeReticle").get_value() - temporizador)
		get_node("../HUD/LeftEyeReticle").set_value(get_node("../HUD/LeftEyeReticle").get_value() - temporizador)
	else:
		get_node("../HUD/RightEyeReticle").set_value(60)
		get_node("../HUD/LeftEyeReticle").set_value(60) 
	if get_node("../HUD/RightEyeReticle").get_value() == 0:
		if Globals.get("gamemode"):
			playcolission(self.get_collider())
		else:
			menu(self.get_collider())
		
		get_node("../HUD/RightEyeReticle").set_value(60)
		get_node("../HUD/LeftEyeReticle").set_value(60)
func menu(objetocolisao):
	if objetocolisao.acao == "start":
		get_tree().change_scene(objetocolisao.cena)
	if objetocolisao.acao == "how":
		get_tree().change_scene(objetocolisao.cena)
	if objetocolisao.acao == "voltar":
		get_tree().change_scene(objetocolisao.cena)
	if objetocolisao.acao == "exit":
		get_tree().quit() 


func playmode():
	if round(Globals.get("tempo")) == 0:
		Globals.set("next",true)
	vidasrestantes = Globals.get("vidas")
	get_node("../HUD/propriedadel").set_text(Globals.get("TIPO")+" "+Globals.get("PROP"))
	get_node("../HUD/propriedader").set_text(Globals.get("TIPO")+" "+Globals.get("PROP"))
	get_node("../HUD/tempor").set_text("Tempo: "+str(Globals.get("tempo")))
	get_node("../HUD/tempol").set_text("Tempo: "+str(Globals.get("tempo")))
	if Globals.get("vidas") < 1:
		Globals.set("gamemode",false)
		get_tree().change_scene("res://GameOVer.tscn")

	pass
func playcolission(objetocolisao):
	get_node("../HUD/Label").set_text(objetocolisao.propriedade)
	if objetocolisao.propriedade == Globals.get("PROP"):
		var pontos = Globals.get("pontos")
		pontos +=1
		get_node("../HUD/pontosl").set_text(str(pontos))
		get_node("../HUD/pontosr").set_text(str(pontos))
		Globals.set("pontos",pontos)
		get_node("../HUD/RightEyeReticle").set_value(60)
		get_node("../HUD/LeftEyeReticle").set_value(60)
		Globals.set("next",true)
	else:
		if(vidasrestantes > 0):
			vidasrestantes -= 1
			Globals.set("vidas",vidasrestantes)
			get_node("../HUD/RightEyeReticle").set_value(60)
			get_node("../HUD/LeftEyeReticle").set_value(60)
	
	pass