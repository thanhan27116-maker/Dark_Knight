extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $container/AnimatedSprite2D
@onready var container: Node2D = $container

@onready var sight: Area2D = $Area2D

var SPEED = 100.0
var is_player_detected = false
var player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sight.body_entered.connect(_on_area_2d_body_entered)
	sight.body_exited.connect(_on_area_2d_body_exited)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void: #Dùng cho vật lí, va chạm
	if is_player_detected and player:
		var  player_pos = player.position
		var direction = (player_pos - self.position).normalized()
		velocity = direction * SPEED
		velocity.y = 0
		container.scale.x = -1 if direction.x < 0 else 1
		
		if direction.x != 0:
			anim.play("walk")			
	else:
		velocity = Vector2.ZERO
		anim.play("idle")
	move_and_slide()
	
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		is_player_detected = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		is_player_detected = false
		player = null
