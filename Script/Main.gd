extends Node2D

# Code principale qui rassemble tout les autres codes

#//////////////////////////////////////////////////////////////////////////////////////////////////////////
#                                       Déclaration des variables
#//////////////////////////////////////////////////////////////////////////////////////////////////////////

var Agent = preload("res://scenes/agent.tscn")
var Impostor = preload("res://scenes/Impostor.tscn")
var docteur = preload("res://scenes/docteur.tscn")
var swarm = [] # Liste vide 
var N = 20 #Nombre d'agents
var M = 1# 1=mode multijoueur ;  0=mode solo
var size = 700# taille de la fenêtre
var mem = []#liste vide
var imp = 0
var comp = 0 #compteur 1
var comp2 = 0 # compteur 2

#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                            Fonctions qui appellent d'autres fonctions
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////

func _ready():#Fonction lancé au début de la scène
	welcome()#Lance la page de démarrage
	
	
func _process(delta): # Fonction actif en continue
	for agent in swarm:
		agent.rules(swarm,mem) #Appelle la fonction rules() dans agent
	mem = []
	for agent in swarm:
		mem.append(agent.vitesse)#rajoute la vitesse des agents dans mem
	update()
	
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                            Fonctions qui définissent les scores
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
func score(): # Affiche le nombre de morts
	$score.text=str(int($score.text)+ 1)
	comp += 1
	if (comp == N/2):
		var camera = get_node("Camera2D")# Victoire de l'imposteur
		camera.current = true
		set_process(false)# Pour éviter que le jeu tournes après la page de fin

func score2(): #Affiche le nombre de guéris
	$score2.text = str(int($score2.text)+1)
	comp2 += 1
	if (comp2 == 2*N and M == 1):
		var camera2= get_node("Camera2D2")#scène de victoire du docteur
		camera2.current = true
		set_process(false)# Pour éviter que le jeu tournes après la page de fin
	if ( comp2 == 2*N and M == 0):
		var camera3 = get_node("Camera2D3")#scène de défaite de l'imposteur
		camera3.current = true
		set_process(false)# Pour éviter que le jeu tournes après la page de fin
		
#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                            Fonction qui lance le jeu
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////

func start(): #Spawn tout les personnages (lance le jeu)
	
	for i in range(N):
		var temp = Agent.instance() #créer les agents
		swarm.append(temp)
		add_child(temp)
		mem.append(temp.vitesse)
		
	
	var imposteur = Impostor.instance()# créer l'imposteur
	add_child(imposteur)
	imposteur.start(swarm,M)


	var doc = docteur.instance()#créer le docteur
	add_child(doc)
	doc.start(swarm,M)
	swarm.append(doc)
	
#////////////////////////////////////////////////////////////////////////////////////////////////////////////
#                              Fonctions de la page de démarrage
#////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
func welcome():#Première page (page de démarrage)
	$Camera2D4.current = true
	
func _on_Button3_pressed():#lorsque le bouton "regles" est cliqué redirige vers la page "règles"
	$Camera2D6.current = true
	
# Ce bouton se situe sur la page règle 
func _on_Button4_pressed():#lorque le Bouton "retour" est cliqué redirige vers la page de démarrage
	$Camera2D4.current = true

func _on_Button_pressed():#lorque le bouton "solo" est cliqué redirige vers la "map" principale
	$Camera2D5.current = true
	M = 0# lance le mode solo
	start()

func _on_Button2_pressed():#lorque le bouton "multi" est cliqué redirige vers la "map" principale
	$Camera2D5.current = true
	M = 1#lance le mode multijoueur
	start()	

func _on_simulation_pressed():# losque le bouton "simulation" est cliqué redirige vers la "map" principale
	$Camera2D5.current = true
	M = 2 # Mode de jeu automatique
	start()






