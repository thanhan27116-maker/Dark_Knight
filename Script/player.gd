extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $container/AnimatedSprite2D
@onready var container: Node2D = $container

var state = "idle"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY



	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		container.scale.x = direction
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0: 
		state = "run"
	else:
		state = "idle"
	
	if not is_on_floor():
		if velocity.y < 0:
			state = "jump"
		else:
			state = "fall"
	Do_Anim(state)
	move_and_slide()

func Do_Anim(state: String) -> void:
	if anim.animation != state:
		anim.play(state)
