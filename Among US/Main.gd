extends Node2D

#Déclaration des variables
#export(PackedScene) var Agent
var Impostor = preload("res://Impostor.tscn")
var Agent = preload("res://test.tscn")
var N = 50 #Nombre d'agents
var size = 700
var swarm = []
var mem = []
var n = 0


func _ready():
	
	for i in range(N):
		var temp = Agent.instance() #Rassemble les scènes
		swarm.append(temp)
		add_child(temp)
		mem.append(temp.vitesse)
	
	var choupette = Impostor.instance()
	add_child(choupette)
	#var temp1 = Impostor.instance()

func _process(delta):
	n += 1
	for agent in swarm:
		agent.rules(swarm,mem) #Ajoute la fonction rules dans agent
		print(agent.position)
	mem = []
	for agent in swarm:
		mem.append(agent.vitesse)#rajoute la vitesse des agents dans mem
	print("[INFO] iterating...n ="+str(n))
	update()
	
