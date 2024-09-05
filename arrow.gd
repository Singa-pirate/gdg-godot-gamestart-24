extends Area2D

const SPEED = 200
var direction = Vector2(1, 0)
var stopped = false
var disappear_timer
var collision_shape
var enemy_hurt_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	disappear_timer = $disappear_timer
	collision_shape = $CollisionShape2D
	enemy_hurt_sound = $"../EnemyHurt"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not stopped:
		position += direction * SPEED * delta


func _on_body_entered(body):
	if "enemy" in body.get_groups():
		enemy_hurt_sound.play()
		body.queue_free()
		queue_free()
	elif body.get_collision_layer_value(3):
		stopped = true
		collision_shape.queue_free()
		disappear_timer.start()
		
func _on_disappear_timer_timeout():
	queue_free()
