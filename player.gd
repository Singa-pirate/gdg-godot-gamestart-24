extends CharacterBody2D

const ARROW = preload("res://arrow.tscn")

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

const MAX_HEALTH = 100
const DAMAGE_INTERVAL = 2

var direction = 1
var health
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var timer
var can_take_damage = true

func _ready():
	health = MAX_HEALTH
	timer = $DamageTimer
	timer.wait_time = DAMAGE_INTERVAL

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if is_on_floor() and \
		(Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_up")):
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_left") and Input.is_action_just_pressed("ui_right"):
		direction = 0
	elif Input.is_action_pressed("ui_right") and Input.is_action_just_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_left") and Input.is_action_just_pressed("ui_right"):
		direction = 1
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		pass
	else:
		direction = Input.get_axis("ui_left", "ui_right")
	
	if not (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
		direction = 0
	
	if Input.is_action_just_pressed("ui_mouse_click"):
		shoot_arrow()
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = lerpf(velocity.x, 0, 0.05)
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
	
	move_and_slide()
	
func take_damage(damage):
	if can_take_damage:
		can_take_damage = false
		timer.start()
		print("%s is damaged by %d health" % [name, damage])
		health -= damage
		if health <= 0:
			queue_free()

func shoot_arrow():
	var arrow = ARROW.instantiate()
	arrow.position = position
	var mouse_position = get_global_mouse_position()
	var shoot_direction = (mouse_position - position).normalized()
	print(shoot_direction)
	arrow.direction = shoot_direction
	arrow.rotation = shoot_direction.angle()
	get_parent().add_child(arrow)

func _on_damage_timer_timeout():
	can_take_damage = true
