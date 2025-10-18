extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $container/AnimatedSprite2D
@onready var container: Node2D = $container
@onready var attack_area: Area2D = $container/attack_area

var state = "idle"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var attack_damage = 25
var max_hp = 100
var current_hp = 0
var is_attacking = false
var can_attack = true 

var is_dead = false
var is_hit = false

func _ready() -> void:
	attack_area.monitoring = false
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("player_attack") and can_attack and is_on_floor():
		attack()
		
	if is_attacking or is_dead:
		velocity.x *= 0.3
		move_and_slide()
		return		
	if is_hit:
		velocity.x = 0
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		container.scale.x = direction
		velocity.x = direction * SPEED
		if direction == 1:
			attack_area.position.x = abs(attack_area.position.x)
		else:
			attack_area.position.x = -abs(attack_area.position.x)
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
	
	anim.play("attack")
	attack_area.monitoring = true
	
	await anim.animation_finished
	
	attack_area.monitoring = false
	is_attacking = false
	await get_tree().create_timer(0.3).timeout
	can_attack = true

func take_damage(amount: float) -> void:
	if is_dead:
		return
	if is_hit:
		return
	if is_attacking:
		return
	current_hp -= amount
	print("current player hp: ", current_hp)
	is_hit = true

	anim.play("hit")
	await get_tree().create_timer(0.3).timeout
	is_hit = false
	
	if current_hp <= 0:
		
		die()
		

func die():
	print("die called")
	if is_dead:
		return
	
	is_dead = true
	print("die")
	anim.play("dead")
	await anim.animation_finished
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)
