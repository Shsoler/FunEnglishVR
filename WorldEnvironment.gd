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

var posicao = [Vector3(-5,2,-5),Vector3(0,2,-5),Vector3(5,2,-5)]
var posicao2 = [Vector3(-3,2,-5),Vector3(3,2,-5)]
func _ready():
 randomize()
 var opt = randi()%(2)+0
 if(opt == 0): 
  distancephase()
 if(opt == 1): 
  colorphase()
 if(opt == 2): 
  sizephase()

func distancephase():
   var objs = {1:["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"],
2:["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"],
3: ["res://modelos/bolavermelha.scn","res://modelos/bolaazul.scn","res://modelos/bolaverde.scn"]} 
   randomize()
   var indiceale = randi()%(objs.size())+1
   var externalScene = objs[indiceale]
   var tam = ["FAR","NEAR"]
   while tam.size() > 0:
     randomize()
     var instanciaindex = randi()%(externalScene.size())+0
     var pos = randi()%(posicao2.size())+0
     print(randi()%(posicao2.size())+0)
     var inst = load(externalScene[instanciaindex]).instance()
     #inst.set_scale(Vector3(0.5,0.5,0.5))
     inst.global_translate(posicao2[pos])
     randomize()
     var indextam = randi()%(tam.size())+0
     var posatual = inst.get_translation()
     if(tam[indextam] == "FAR"):
      inst.global_translate(Vector3(0,0,-7)+posatual)
     posicao2.remove(pos)
     inst.adicionarprop(tam[indextam])
     tam.remove(indextam)
     self.add_child(inst)
     externalScene.remove(instanciaindex)
     get_node("TestCube/Camera/Label").set_text(inst.propriedade)

func sizephase():
 var objs = {1:["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"],
2:["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"],
3: ["res://modelos/bolavermelha.scn","res://modelos/bolaazul.scn","res://modelos/bolaverde.scn"]} 
 randomize()
 var indiceale = randi()%(objs.size())+1
 var externalScene = objs[indiceale]
 var tam = ["SMALL","MEDIUM","BIG"]
 while externalScene.size() > 0:
   randomize()
   var instanciaindex = randi()%(externalScene.size())+0
   var pos = randi()%(posicao.size())+0
   print(randi()%(posicao.size())+0)
   var inst = load(externalScene[instanciaindex]).instance()
   inst.set_scale(Vector3(0.5,0.5,0.5))
   inst.global_translate(posicao[pos])
   randomize()
   var indextam = randi()%(tam.size())+0
   var posatual = inst.get_translation()
   if(tam[indextam] == "BIG"):
    inst.set_scale(Vector3(1.3,1.3,1.3))
    #inst.global_translate(posatual+Vector3(0,0,posatual.x*-1.3))
   #if(tam[indextam] == "MEDIUM"):
    #inst.set_scale(Vector3(1,1,1))
   if(tam[indextam] == "SMALL"):
    inst.set_scale(Vector3(0.3,0.3,0.3))
   posicao.remove(pos)
   inst.adicionarprop(tam[indextam])
   tam.remove(indextam)
   self.add_child(inst)
   externalScene.remove(instanciaindex)
   get_node("TestCube/Camera/Label").set_text(inst.propriedade)


func colorphase():
 #var externalScene = ["res://modelos/carro.scn","res://modelos/carroazul.scn","res://modelos/carrogreen.scn"]
 #var externalScene = ["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"] 
 #var externalScene = ["res://modelos/bolavermelha.scn","res://modelos/bolaazul.scn","res://modelos/bolaverde.scn"] 
#var externalScene = ["res://StaticBody.tscn","res://StaticBody.tscn","res://StaticBody.tscn"]
 var objs = {1:["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"],
2:["res://modelos/cubovermelho.scn","res://modelos/cuboazul.scn","res://modelos/cuboverde.scn"],
3: ["res://modelos/bolavermelha.scn","res://modelos/bolaazul.scn","res://modelos/bolaverde.scn"]} 
 randomize()
 var indiceale = randi()%(objs.size())+1
 print("ola"+str(indiceale))
 var externalScene = objs[indiceale]
 

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
 