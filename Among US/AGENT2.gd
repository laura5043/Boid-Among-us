extends Area2D

# Declare member variables here

var vitesse=Vector2(0,0)
var gather_sight = 50
var separation_sight = 50
var alignement_sight = 70
var separation_coeff = 1
var alignment_coeff = 0.4
var gather_coeff = 0.8
var rng= RandomNumberGenerator.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	position = Vector2(rng.randi_range(0,1000),rng.randi_range(0,1000))
	vitesse = Vector2(rng.randf_range(-5,5), rng.randf_range(-5,5))
	vitesse.normalized()
	
	
	set_process(true)
	
func rules(swarm): # swarm est défini dans Main et pas dans agent : cette fonction passe swarm à Agent 
	var temp
	var temp2
	var temp3
	temp=gather(swarm)
	temp2 = separate(swarm)
	
	#
	vitesse+=temp


func gather(swarm):
	var centroid = Vector2(0,0) #calcul centroid 
	var N=0
	for agent in swarm: 
		var d = dist(agent)
		if d<gather_sight:
			N+=1
			centroid+=agent.position
	centroid /= N      # /= c'est centroid= centroid/N
	return gather_coeff*(centroid - position).normalized() 	 
	
	# gather modifie la vitesse

func separate(swarm): 
	var centroid = Vector2(0,0)
	var N=0
	for agent in swarm: 
		var d = dist(agent)
		if d<separation_sight:
			N+=1
			centroid+=agent.position
	centroid /= N      # /= c'est centroid= centroid/N
	return separation_coeff*(centroid - position).normalized() #applique sur tous les voisins dans son champs de vision
	
func align():
	pass

func dist(agent): #distance entre 2 agent 
	return position.distance_to(agent.position)

func dir(agent):
	return position.direction_to(agent.position)


func _process(delta): 
	update()
	bounce()
	
func _draw(): 
	#print(position)
	#print(vitesse)
	#draw_circle(position, 10, Color(1,1,1))
	position+=vitesse 

	
		

func bounce(): 
	if(position.x>500 or position.x<0): 
		vitesse.x=-vitesse.x
	elif(position.y>500 or position.y<0):
		vitesse.y=-vitesse.y

