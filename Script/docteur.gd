


extends KinematicBody2D

#Code qui définit les caractéristiques du docteur

#///////////////////////////////////////////////////////////////////////////////////////////////////
#                         Déclaration des variables
#////////////////////////////////////////////////////////////////////////////////////////////////////

var joueur = 0 
var agent = preload("res://scenes/agent.tscn")
var gather_sight = 700 #Champ de vision pour le rassemblement
var gather_coeff = 2.5 #"Force" de rassemblement
var vitesse = Vector2() # Créer un vecteur
var imp =[] #swarm
var limite_V = 100
var infecter = 0 # Indique si l'agent est infecté ou pas
var mort = 0 # Indique si l'agent est mort ou pas
var speed = 150 # Défini la vitesse du docteur en multijoueur

#/////////////////////////////////////////////////////////////////////////////////////////////////////
#                          Fonctions qui appellent d'autres fonctions
#///////////////////////////////////////////////////////////////////////////////////////////////////

func _ready():
	position = Vector2(100,100)#Emplacement de départ
	randomize()
	position = Vector2(rand_range(300,400),rand_range(300,400))#Défini la position de départ des agents
	vitesse = Vector2(rand_range(-3,3), rand_range(-3,3))#Défini la vitesse maximum /minimum des agents
	vitesse.normalized()

func start(swarm,M):
	joueur = M # Défini le mode de jeu (solo ou multijoueur)
	imp = swarm

func _process(delta):
	if (joueur == 1):#Fonction utilisé en mode multijoueur
		mouvement2()
		guerison(imp)
		flip()
		limite_V = 150
	else :#Fonctions utilisé en mode solo et automatique
		flip()
		guerison(imp)
		bounce()
		collision()
		vitesse += gather(imp)
		
	vitesse = moyenne(vitesse)#Limiteur de vitesse
	vitesse = Vector2(vitesse.x*limite_V,vitesse.y*limite_V)
	move_and_slide(vitesse,Vector2(0,-1))
	
#/////////////////////////////////////////////////////////////////////////////////////////////////////////
#                   Fonctions qui définissent les déplacements du docteur
#////////////////////////////////////////////////////////////////////////////////////////////////////////	

func moyenne(velbis): #Calcule la moyenne de la vitesse
	var v = abs(velbis.x)+abs(velbis.y)
	if(v==0):
		return Vector2(0,0)
	else:
		return (Vector2(velbis.x/v,velbis.y/v))
			
				
func dist(agent): #distance entre 2 agent 
	return position.distance_to(agent.position)	
	
func bounce(): #Permet aux agents de rebondir sur les bords
	if(position.x>650 or position.x<0): 
		vitesse.x=-vitesse.x
	elif(position.y>450 or position.y<0):
		vitesse.y=-vitesse.y
	
		
func gather(imp):#Fonction qui permet au docteur d'être attiré par les infectés
	var centroid = Vector2(0,0) #calcul du centroid 
	var N=0
	for agent in imp: 
		if (agent.mort == 1):
			pass
		else:
			var d = dist(agent)
			if (agent.infecter == 1):
				if d<gather_sight:
					N+=1
					centroid+=agent.position
	if N == 0 :
		return Vector2(0,0)
	centroid /= N      # /= c'est centroid= centroid/N
	return gather_coeff*(centroid - position).normalized() 	 
	
func collision(): # Permet aux agents rebondir contre les obstacles
	if(is_on_ceiling() or is_on_floor()): 
		vitesse.y = -vitesse.y
	if(is_on_wall()):
		vitesse.x = -vitesse.x
	move_and_slide(vitesse, Vector2(0,-1))


func flip():#Retourne le docteur losqu'il change de direction
	if (vitesse.x<0):
		$CollisionShape2D/docteur.flip_h = true
	else :
		$CollisionShape2D/docteur.flip_h = false
		

func mouvement2():#Définit les commandes du docteur (mode multijoueur)
	vitesse = get_global_mouse_position() - position
	vitesse = moyenne(vitesse)*speed

#////////////////////////////////////////////////////////////////////////////////////////////////////////
#                       Fonction de guérison du docteur
#////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
func guerison(imp):#indique quand le vert est infecté
	var d
	for agent in imp: 
		d= dist(agent)
		if (d<=50 and d!= 0 ):
				agent.gueri()
	
	
func gueri():
	pass
	
func infect():
	pass
	
func rules(swarm,mem):
	pass
