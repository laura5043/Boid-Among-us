

extends KinematicBody2D

#Code définissant les caractéristiques de l'imposteur

var agent = preload("res://scenes/agent.tscn")
var vitesse = Vector2() # Créer un vecteur
var speed = 200 # Définit la vitesse de l'imposteur
var Vecteur = Vector2(0,0)# Définit un vecteur
var imp =[]# Introduit une liste vide
var infecter = 0# Variable indiquant si l'agent est infecté
var limite_V = 80
var joueur = 0 # mode de jeu
var gather_coeff = 1.5 # Force de rapprochement 
var gather_sight = 250 # Champ de vision 
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                            Fonctions qui appellent d'autres fonctions
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////

func _ready():
	randomize()
	position = Vector2(200, 315)#Emplacement de départ
	vitesse = Vector2(rand_range(-3,3), rand_range(-3,3))
	vitesse.normalized()
	
func start(swarm,M):# Reprend et renomme les variables récupérer dans main
	imp=swarm
	joueur = M
	
func _process(delta):
	if (joueur == 2): # Mode simulation
		infection(imp)
		flip()
		collision()
		vitesse += gather(imp)
	else: # Mode multijoueur et solo
		mouvement()
		infection(imp)
		limite_V = 200
		
	vitesse = moyenne(vitesse)#Limiteur de vitesse
	vitesse = Vector2(vitesse.x*limite_V,vitesse.y*limite_V)
	move_and_slide(vitesse)
	
#////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                        Fonctions qui définissent les déplacements de l'imposteur
#///////////////////////////////////////////////////////////////////////////////////////////////////////////
			
	
func mouvement():#Définit les commandes de l'imposteur
	vitesse.x = 0
	vitesse.y = 0
	if Input.is_action_pressed("ui_right"): #Commande vers la droite
		vitesse.x+=speed
		$CollisionShape2D/impostor.flip_h = false # retourne l'image
	if Input.is_action_pressed("ui_left"):#Commande vers la gauche
		vitesse.x-=speed
		$CollisionShape2D/impostor.flip_h = true
	if Input.is_action_pressed("ui_up"):#Commande vers le haut
		vitesse.y-=speed
	if Input.is_action_pressed("ui_down"):#Commande vers le bas
		vitesse.y+=speed
	
	
func gather(imp):#Fonction qui permet à l'imposteur d'être attiré par les agents sain (mode simulation)
	var centroid = Vector2(0,0) #calcul du centroid 
	var N=0
	for agent in imp: 
		if (agent.mort == 1):
			pass
		else:
			var d = dist(agent)
			if (agent.infecter == 0):
				if d<gather_sight:
					N+=1
					centroid+=agent.position
	if N == 0 :
		return Vector2(0,0)
	centroid /= N      # /= c'est centroid= centroid/N

	return gather_coeff*(centroid - position).normalized() 	 
	
func moyenne(velbis): #Calcule la moyenne de la vitesse
	var v = abs(velbis.x)+abs(velbis.y)
	if(v==0):
		return Vector2(0,0)
	else:
		return (Vector2(velbis.x/v,velbis.y/v))
		
func flip():#Retourne l'imposteur losqu'il change de direction
	if (vitesse.x<0):
		$CollisionShape2D/impostor.flip_h = true
	else :
		$CollisionShape2D/impostor.flip_h = false
	
func collision(): # Permet aux agents rebondir contre les obstacles
	if(is_on_ceiling() or is_on_floor()): 
		vitesse.y = -vitesse.y
	if(is_on_wall()):
		vitesse.x = -vitesse.x
	move_and_slide(vitesse, Vector2(0,-1))


#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                              Fonctions qui définissent la contamination
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////

func infection(imp):#indique quand le vert est infecté
	var d
	for agent in imp: 
		d= dist(agent)
		if (d<=50 and d!= 0):
			agent.infect()
			
				
func dist(agent): #distance entre 2 agent 
	return position.distance_to(agent.position)	

func gueri(): 
 pass
	

func infect():
	pass

	


	
