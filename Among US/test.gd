extends KinematicBody2D

# Déclaration des variables

var vitesse = Vector2(0,0) #Définition d'un vecteur
var gather_sight = 150 #Champ de vision pour le rassemblement
var separation_sight = 25 #Champ de vision pour la séparation 
var alignement_sight = 80 #Champ de vision pour l'alignement
var separation_coeff = 0.5 # "Force" de séparation
var alignment_coeff = 0.9 #"Force" d'alignement
var gather_coeff = 0.8#"Force" de rassemblement
var rng= RandomNumberGenerator.new()#Générateur de nombre aléatoire
var limite_V = 100#Limiteur de vitesse

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	position = Vector2(rand_range(200,300),rand_range(200,300))#Défini les positions maximum / minimum des agents
	vitesse = Vector2(rand_range(-3,3), rand_range(-3,3))#Défini la vitesse maximum /minimum des agents
	vitesse.normalized()
	
	set_process(true)
	
func rules(swarm,mem): # cette fonction appelle les fonctions dans test
	var temp	
	temp= gather(swarm)
	temp+= separate(swarm)
	temp+= align(swarm,mem)
	vitesse += temp
	
	vitesse = moyenne(vitesse)#Limiteur de vitesse
	vitesse = Vector2(vitesse.x*limite_V,vitesse.y*limite_V)
	pass
	
func moyenne(velbis): #Calcule la moyenne de la vitesse
	var v = abs(velbis.x)+abs(velbis.y)
	if(v==0):
		return Vector2(0,0)
	else:
		return (Vector2(velbis.x/v,velbis.y/v))


func gather(swarm):#Fonction qui permet de rassembler les agents
	var centroid = Vector2(0,0) #calcul du centroid 
	var N=0
	for agent in swarm: 
		var d = dist(agent)
		if d<gather_sight:
			N+=1
			centroid+=agent.position
	centroid /= N      # /= c'est centroid= centroid/N
	return gather_coeff*(centroid - position).normalized() 	 
	
	
func separate(swarm):#Fonction qui permet la séparation des agents
	var temp = Vector2(0,0)
	var N=0
	for agent in swarm: 
		if dist(agent)<separation_sight:
			N+=1
			temp += position - agent.position
	return separation_coeff*(temp/N)
	
func align(swarm,mem): # Focntion qui permet de créer un groupe cohérent entre les agents
	var centroid = Vector2(0,0)
	var d=0
	var N = 0
	for i in range(len(swarm)):
		d =dist(swarm[i])
		if d <= alignement_sight:
			N+=1
			centroid+=mem[i] - vitesse
		
	return alignment_coeff*(centroid.normalized())
	
func dist(agent): #distance entre 2 agent 
	return position.distance_to(agent.position)

func dir(agent):#Direction des agents
	return position.direction_to(agent.position)


func _process(delta): 
#	update()
	bounce()
	move_and_slide(vitesse)
	
func _draw(): 
	#print(position)
	#print(vitesse)
	#draw_circle(position, 10, Color(1,1,1))
	position+=vitesse 



func bounce(): #Permet aux agents de rebondir sur les bords
	if(position.x>700 or position.x<0): 
		vitesse.x=-vitesse.x
	elif(position.y>700 or position.y<0):
		vitesse.y=-vitesse.y
