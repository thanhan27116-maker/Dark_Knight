extends TextureProgressBar


@onready var enemy = get_parent().get_node("skeleton")



func _ready() -> void:	
	max_value = enemy.max_ưhp
	value = enemy.current_hp
	enemy.health_changed(_on_health_changed) 
	
	
func _on_health_changed(new_health: float):
	value = new_health
	
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
