

extends KinematicBody2D

#Le code ci dessous contrôle les agents (bonhommes verts)


#/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                                          Déclaration des variables
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////

var vitesse = Vector2(0,0) #Définition d'un vecteur
var gather_sight = 150 #Champ de vision pour le rassemblement
var separation_sight = 25 #Champ de vision pour la séparation 
var alignement_sight = 80 #Champ de vision pour l'alignement
var separation_coeff = 0.5 # "Force" de séparation
var alignment_coeff = 0.9 #"Force" d'alignement
var gather_coeff = 0.8#"Force" de rassemblement
var rng= RandomNumberGenerator.new()#Générateur de nombre aléatoire
var limite_V = 100 #Limiteur de vitesse

var infecter = 0 #Variable qui définit si l'agent est infecté ou non
var mort = 0 #Variable qui définit si l'agent est mort ou non
var gueri = 0 #Variable qui définit si l'agent est guéri ou non

#//////////////////////////////////////////////////////////////////////////////////////////////////////////
#                                Fonctions qui appellent d'autres fonctions
#//////////////////////////////////////////////////////////////////////////////////////////////////////////

func _ready():# Fonction qui se lance au début de la scène
	randomize()
	position = Vector2(rand_range(300,400),rand_range(300,400))#Défini la position de départ des agents
	vitesse = Vector2(rand_range(-3,3), rand_range(-3,3))#Défini la vitesse maximum /minimum des agents
	vitesse.normalized()
	
	$CollisionShape2D/AnimatedSprite.visible = false # Rend invisible l'animation de mort
	set_process(true)
	
func _process(delta): # Toutes les fonctions dans process() sont appelées en continu
	bounce()
	flip()
	collision()
	
func rules(swarm,mem): # cette fonction appelle les fonctions dans agent
	if (mort==1):# Si l'agent est "mort" aucune fonction est appelée
		pass
	elif (infecter == 1): #Si l'agent est "infecté" on ajoute gather(),separate() et align() à la vitesse
		var temp
		temp= gather(swarm)
		temp+= separate(swarm)
		temp+= align(swarm,mem)
		vitesse +=temp
	else : # Idem pour les agents restant c'est à dire non "infecté"
		var temp	
		temp= gather(swarm)
		temp+= separate(swarm)
		temp+= align(swarm,mem)
		vitesse += temp
	vitesse = moyenne(vitesse) #Appel la fonction moyenne() pour réduire la vitesse
	vitesse = Vector2(vitesse.x*limite_V,vitesse.y*limite_V)
	
#///////////////////////////////////////////////////////////////////////////////////////////////////////////
#                            Fonctions définissant les déplacements des agents
#///////////////////////////////////////////////////////////////////////////////////////////////////////////

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
			temp += position - agent.position # temp = temp + (position - agent.position)
	return separation_coeff*(temp/N)
	
func align(swarm,mem): # Fonction qui permet de créer un groupe cohérent entre les agents
	var centroid = Vector2(0,0)
	var d=0
	var N = 0
	for i in range(len(swarm)-1):# le docteur est en trop
		d =dist(swarm[i])
		if d <= alignement_sight:
			N+=1
			centroid+=mem[i] - vitesse
		
	return alignment_coeff*(centroid.normalized())
	
func dist(agent): #distance entre 2 agent 
	return position.distance_to(agent.position)

func dir(agent):#Direction des agents
	return position.direction_to(agent.position)

	
func flip():#Permet au agent de se retourner lorqu'ils changent de direction
	if (vitesse.x<0):
		$CollisionShape2D/green_crew.flip_h = true
	else :
		$CollisionShape2D/green_crew.flip_h = false
		
#///////////////////////////////////////////////////////////////////////////////////////////////////////////
#                              Fonctions qui délimitent la zone de déplacement des agents
#//////////////////////////////////////////////////////////////////////////////////////////////////////////

func bounce(): #Permet aux agents de rebondir sur les bords
	if(position.x>700 or position.x<0): 
		vitesse.x=-vitesse.x
	elif(position.y>500 or position.y<0):
		vitesse.y=-vitesse.y
		
func collision(): # Permet aux agents rebondir contre les obstacles
	if(is_on_ceiling() or is_on_floor()): 
		vitesse.y = -vitesse.y
	if(is_on_wall()):
		vitesse.x = -vitesse.x
	move_and_slide(vitesse, Vector2(0,-1))

#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                          Fonctions qui définissent l'état des agents
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
func infect(): # Fonction appelé dans impostor.gd pour infecter l'agent
	if(mort == 1):# Si l'agent est "mort" on fait rien
		pass
	elif (infecter == 0):# Si l'agent non infecté on l'infecte
		infecter = 1
		limite_V = 70 # Ralenti l'infecté
		$CollisionShape2D/green_crew.play("blue")#Transforme en bleu (infecté)
		$mort.start()# Lance le décompe avant la mort de l'infecté
	else:
		pass
	
	
func gueri(): # Définit l'état de l'agent lorqu'il est guéri
	if (infecter == 1 ):
		infecter = 2 #évite qu'il soit infecté directement après (peut être tout sauf 0 ou 1)
		limite_V = 100
		$CollisionShape2D/green_crew.play("green")#Transforme en vert
		get_parent().score2()#Appel la fonction score2() dans main
		$immu.start()#Lance le temps d'immunité de l'agent guéri
	else:
		pass

func mort(): # Fonction actif lorsque l'agent est "mort" et supprime son collisionShape2D
	if (mort == 1):
		$CollisionShape2D.disabled = true
	else:
		pass

func _on_mort_timeout():# Fonction appelé par infect()  et définit la mort de l'agent infecté (après 8 secondes)
	if (infecter == 1):
		$CollisionShape2D/AnimatedSprite.visible = true
		$CollisionShape2D/green_crew.visible = false
		$CollisionShape2D/AnimatedSprite.play("death") #Animation de mort
		mort = 1 # Indique que l'agent est "mort"
		infecter = 0 
		limite_V = 0 #Rend l'agent "mort" immobile
		mort()
		get_parent().score()# Appelle score() dans le parent : main
		$corp.start()
 
		
func _on_immu_timeout(): # Fin du temps d'immunité l'agent est de nouveau infectable (après 3 secondes)
	if (infecter == 2):
		infecter = 0


func _on_corp_timeout():# Fonction qui enlève le corp "mort" de l'agent (après 3 secondes)
	if (mort == 1):
		position = Vector2(-3000,-3000) # Téléporte le corp à (-3000,-3000)
		
