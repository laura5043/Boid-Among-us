extends Area2D

# Declare member variables here

var vitesse = Vector2(0,0)
var gather_sight = 100
var separation_sight = 70
var alignement_sight = 80
var separation_coeff = 1
var alignment_coeff = 0.4
var gather_coeff = 0.8
var rng= RandomNumberGenerator.new()
var limite_V = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	position = Vector2(rand_range(200,300),rand_range(200,300))
	vitesse = Vector2(rand_range(-3,3), rand_range(-3,3))
	vitesse.normalized()
	
	
	set_process(true)
	
func rules(swarm,mem): # swarm est défini dans Main et pas dans agent : cette fonction passe swarm à Agent 
	var temp	
	temp= gather(swarm)
	#temp+= separate(swarm)
	#temp+= align(swarm,mem)
	vitesse += temp
	vitesse = moyenne(vitesse)
	vitesse = Vector2(vitesse.x*limite_V,vitesse.y*limite_V)
	pass
	
func moyenne(velbis):
	var v = abs(velbis.x)+abs(velbis.y)
	if(v==0):
		return Vector2(0,0)
	else:
		return (Vector2(velbis.x/v,velbis.y/v))


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

func separate(swarm): #TEST
	var temp = Vector2(0,0)
	var N=0
	for agent in swarm: 
		if dist(agent)<separation_sight:
			N+=1
			temp += position - agent.position
	return separation_coeff*(temp/N)
	
func align(swarm,mem):#TEST
	return 0
		


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
	if(position.x>1000 or position.x<0): 
		vitesse.x=-vitesse.x
	elif(position.y>1000 or position.y<0):
		vitesse.y=-vitesse.y
