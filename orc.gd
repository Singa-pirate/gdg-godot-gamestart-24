extends CharacterBody2D


const SPEED = 30.0
const DAMAGE = 20
const JUMP_VELOCITY = -300

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 1 # 1 means right
var jump_timer

func _ready():
	jump_timer = $JumpTimer
	start_jump_timer()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	

func _on_hitbox_body_entered(body):
	body.take_damage(DAMAGE)

func start_jump_timer():
	var duration = randi_range(2, 4)
	jump_timer.wait_time = duration
	jump_timer.start()

func _on_jump_timer_timeout():
	velocity.y = JUMP_VELOCITY
	start_jump_timer()
