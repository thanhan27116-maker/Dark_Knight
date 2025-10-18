extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $container/AnimatedSprite2D
@onready var container: Node2D = $container
@onready var sight: Area2D = $sight
@onready var hurt_box: Area2D = $hurt_box
@onready var attack: Area2D = $container/attack


var max_hp = 100 
var current_hp = max_hp
var is_dead = false
var is_hit = false

var attack_damage = 25
var is_attacking = false
var can_attack = true

var SPEED = 100.0
var is_player_detected = false
var player = null

var last_player_direction = 1

func _ready() -> void:
	sight.body_entered.connect(_on_area_2d_body_entered)
	sight.body_exited.connect(_on_area_2d_body_exited)
	current_hp = max_hp
	attack.monitoring = true

#Di chuyển
func _physics_process(delta: float) -> void: 
	if is_dead:
		return
	if is_hit:
		return
		
	
	velocity += get_gravity() * delta
	

	if is_player_detected and player:
		var  player_pos = player.position
		var direction = (player_pos - self.position).normalized()
		last_player_direction = -1 if direction.x < 0 else 1
		
		container.scale.x = last_player_direction
		if direction.x == 1:
			attack.position.x = abs(attack.position.x)
		if direction.x == -1:
			attack.position.x = -abs(attack.position.x)
		if is_attacking:
			velocity = Vector2.ZERO
		else:
			velocity = direction * SPEED
			velocity.y = 0
			anim.play("walk")			
	else:
		#velocity = Vector2.ZERO
		#velocity.y = 0
		#anim.play("idle")
	
		container.scale.x = last_player_direction
	move_and_slide()
	
	#tầm nhìn enemy
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		is_player_detected = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		is_player_detected = false
		player = null

#Tấn công player

func _on_attack_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		player = body
		if not is_attacking:
			is_attacking = true
			attacking_loop()


func _on_attack_body_exited(body: Node2D) -> void:

	if body == player:
		player = null
		is_attacking = false
		print("player left")


func attacking_loop():
	is_attacking = true
	
	while player and not is_dead:
		await attack_player()
		await get_tree().create_timer(0.6).timeout
		
	is_attacking = false


func attack_player():
	if is_dead or not player:
		return
	anim.play("attack")
	await get_tree().create_timer(0.5).timeout
	
	if is_dead:
		return
	
	if player and player.has_method("take_damage"):
		player.take_damage(attack_damage)

	await anim.animation_finished

		
#Enemy Die
func take_damage(amount: float):
	if is_dead or is_hit:
		is_attacking = false
		can_attack = false
		return
	current_hp -= amount
	print("Current enemy hp: ", current_hp)
	
	is_hit = true
	can_attack = false
	var was_attack = is_attacking
	is_attacking = false
	
	anim.play("hit")
	await anim.animation_finished
	is_hit = false
	can_attack = true
	if current_hp <= 0:
		die()
		return
	else:
		if current_hp > 0 and  was_attack and player:
			is_attacking = true
			attacking_loop()

func die():
	if is_dead:
		return
	is_dead = true
	anim.play("dead")
	await anim.animation_finished
	
	queue_free()
