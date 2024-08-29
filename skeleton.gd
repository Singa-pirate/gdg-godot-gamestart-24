extends CharacterBody2D


const SPEED = 30.0
const DAMAGE = 10

var direction = 1 # 1 means right



func _physics_process(delta):
	if direction == 1:
		$Sprite2D.flip_h = false
	if direction == -1:
		$Sprite2D.flip_h = true
	
	velocity.x = SPEED * direction
	# move_and_slide()
	
	# collision contains information about the collision that happened in the movement
	var collision = move_and_collide(velocity * delta)
	
	# if a collision happened
	if collision:
		# if the perpendicular direction of the collision is horizontal
		if (collision.get_normal() == Vector2.LEFT || collision.get_normal() == Vector2.RIGHT):
			# flip the sign of direction --> the skeleton turns around
			direction *= -1
	

func _on_hitbox_body_entered(body):
	body.take_damage(DAMAGE)
