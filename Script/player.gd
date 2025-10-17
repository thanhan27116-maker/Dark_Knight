extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $container/AnimatedSprite2D
@onready var container: Node2D = $container
@onready var attack_area: Area2D = $attack_area



var state = "idle"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var attack_damge = 25
var is_attacking = false
var can_attack = true 

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("player_attack") and can_attack:
		#attack()
		
	if is_attacking:
		return		
	
	if not is_on_floor():
		velocity += get_gravity() * delta

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

func Do_Anim(ani: String) -> void:
	if anim.animation != ani:
		anim.play(ani)
		
func attack():	
	is_attacking = true
	can_attack = false
	
	anim.play("atack")
	attack_area.monitoring = true
	
	await anim.animation_finished
	
	attack_area.monitoring = false
	is_attacking = false
	await get_tree().create_timer(0.3).timeout
	can_attack = true
	
	
	
	
	
	
