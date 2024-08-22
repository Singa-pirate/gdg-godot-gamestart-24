extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	velocity.y += gravity * delta
	
	if is_on_floor() and \
		(Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_up")):
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = - SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		# add some conditional statements here
		velocity.x = lerpf(velocity.x, 0, 0.05)
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
	
	
	
	move_and_slide()
	
	
