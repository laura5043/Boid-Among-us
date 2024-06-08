extends Node2D

# Declare member variables here. Examples:
var N = 40
var size = 1000
var swarm = []

# set your code here

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	# set your code here
	
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func rules():
	
	# set your code here
	
	pass

func separate():
	
	# set your code here
	
	pass

func dist(target, pos):
	
	# set your code here
	
	pass

func gather():
	
	# set your code here
	
	pass

func align():
	
	# set your code here
	
	pass


func _draw():
	
	# set your code here
	
	pass
