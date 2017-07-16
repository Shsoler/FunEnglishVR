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
 var externalScene = ["res://modelos/carro.scn","res://modelos/carro.scn","res://modelos/carro.scn"]
 #var externalScene = ["res://StaticBody.tscn","res://StaticBody.tscn","res://StaticBody.tscn"]
 
 for e in externalScene:
   randomize()
   var corind = randi()%corematriz.size()+0
   var cor = corematriz[corind]
   corematriz.remove(corind)
   var pos = randi()%(posicao.size())+0
   print(randi()%(posicao.size())+0)
   var inst = load(e).instance()
   inst.set_scale(Vector3(0.5,0.5,0.5))
   inst.global_translate(posicao[pos])
   posicao.remove(pos)
   #var x = inst.get
   inst.mudacor(cor)
   
   if cor == Color(255,0,0):
    inst.adicionarprop("RED")
   if cor == Color(0,255,0):
    inst.adicionarprop("GREEN")
   if cor == Color(0,0,255):
    inst.adicionarprop("BLUE") 
   get_node("TestCube/Camera/Label").set_text(inst.propriedade)
   self.add_child(inst)

