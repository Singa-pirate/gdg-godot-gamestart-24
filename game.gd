extends Node

const LEVEL_1 = preload("res://level1.tscn")
const LEVEL_2 = preload("res://level_2.tscn")

const LEVELS = [LEVEL_1, LEVEL_2]

var current_level

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = LEVEL_1.instantiate()
	add_child(current_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_level(n):
	var new_level = LEVELS[n-1].instantiate()
	add_child(new_level)
	current_level.queue_free()
	current_level = new_level

