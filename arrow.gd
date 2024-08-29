extends Area2D

const SPEED = 200
var direction = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * SPEED * delta


func _on_body_entered(body):
	if body.get_collision_layer_value(2):
		body.queue_free()
		queue_free()
	elif body.get_collision_layer_value(3):
		queue_free()
