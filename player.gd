extends CharacterBody2D

const ARROW = preload("res://arrow.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

const MAX_HEALTH = 100
const DAMAGE_INTERVAL = 2
const MAX_ARROW_COUNT = 1
const ARROW_REPLENISH_TIME = 2

var direction = 1
var health
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var timer
var can_take_damage = true
var arrow_count
var arrow_timer
var sprite
var animation_player
var health_bar
var player_hurt_sound
var arrow_label

func _ready():
	health = MAX_HEALTH
	timer = $DamageTimer
	timer.wait_time = DAMAGE_INTERVAL
	arrow_count = MAX_ARROW_COUNT
	arrow_timer = $ArrowTimer
	arrow_timer.wait_time = ARROW_REPLENISH_TIME
	sprite = $AnimatedSprite2D
	animation_player = $AnimationPlayer
	health_bar = $"../UI/HealthBar"
	player_hurt_sound = $"../PlayerHurt"
	arrow_label = $"../UI/ArrowLabel"
	arrow_label.text = "x%d" % MAX_ARROW_COUNT

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
	
	if direction:
		sprite.set_animation("running")
		velocity.x = direction * SPEED
	else:
		sprite.set_animation("idle")
		if is_on_floor():
			velocity.x = lerpf(velocity.x, 0, 0.1)
		else:
			velocity.x = lerpf(velocity.x, 0, 0.05)
	
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	
	move_and_slide()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_mouse_click"):
		shoot_arrow()
	
func take_damage(damage):
	if can_take_damage:
		player_hurt_sound.position = position
		player_hurt_sound.play()
		animation_player.play("take_damage")
		can_take_damage = false
		timer.start()
		print("%s is damaged by %d health" % [name, damage])
		health -= damage
		health_bar.value = health
		if health <= 0:
			queue_free()

func shoot_arrow():
	if arrow_count > 0:
		arrow_count -= 1
		arrow_label.text = "x%d" % arrow_count
		arrow_timer.start()
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


func _on_arrow_timer_timeout():
	arrow_count = MAX_ARROW_COUNT
	arrow_label.text = "x%d" % arrow_count
