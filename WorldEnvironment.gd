extends WorldEnvironment
var cores = {"RED":Color(255,0,0),"BLUE":Color(0,0,255),"GREEN":Color(0,255,0)}
var corematriz = [Color(255,0,0),Color(0,0,255),Color(0,255,0)]
var global
var root
var parent


func init_root(global_node, root_node, parent_node):
    global = global_node
    root = root_node
    parent = parent_node

var posicao = [Vector3(-5,0,-5),Vector3(0,0,-5),Vector3(5,0,-5)]
func _ready():
 colorphase()

func colorphase():
 var externalScene = ["res://modelos/carro.scn","res://modelos/carroazul.scn","res://modelos/carrogreen.scn"]
 #var externalScene = ["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"] 
 #var externalScene = ["res://modelos/bolavermelha.scn","res://modelos/bolaazul.scn","res://modelos/bolaverde.scn"] 
#var externalScene = ["res://StaticBody.tscn","res://StaticBody.tscn","res://StaticBody.tscn"]
 
 for e in externalScene:
   randomize()
   var pos = randi()%(posicao.size())+0
   print(randi()%(posicao.size())+0)
   var inst = load(e).instance()
   inst.set_scale(Vector3(0.5,0.5,0.5))
   inst.global_translate(posicao[pos])
   posicao.remove(pos)
   inst.adicionarprop(inst.cor)
   self.add_child(inst)

 var coraleatoria = randi()%(3)+0
 if coraleatoria == 0:
  get_node("TestCube/Camera/Label").set_text("RED")
 if coraleatoria == 1:
  get_node("TestCube/Camera/Label").set_text("BLUE")
 if coraleatoria == 2:
  get_node("TestCube/Camera/Label").set_text("GREEN")
 