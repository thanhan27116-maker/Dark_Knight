extends TextureProgressBar


@onready var enemy = get_parent()

func _ready() -> void:	
	
	if enemy and enemy.is_in_group("enemy"):
		enemy.health_changed.connect(_on_health_changed)
		max_value = enemy.max_hp
		value = enemy.current_hp
	else:
		print("Enemy null")
	
func _on_health_changed(new_health: float):
	self.value = new_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
