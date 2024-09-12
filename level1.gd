extends Node2D

const SPEED = 1000
var direction = 1
var count = 0

func _ready():
	var a = 1 + 1
	
	direction = -1
	
	print_direction()
	direction = 0
	
	print_direction()
	
	var boolean = direction == 1 and (SPEED > 500 or direction == -1)
	
	print(boolean)
	
	pass

func _physics_process(delta):
	pass

func print_direction():
	if direction == 1:
		print("moving to the right")
	elif direction == -1:
		print("moving to the left")
	else:
		print("not moving")
	
