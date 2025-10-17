extends Node

@onready var panel: Panel = $"../UI/Panel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.visible = false	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('back_to_menu'):
		panel.visible = true
		get_tree().paused = true



func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
	


func _on_resume_pressed() -> void:
	get_tree().paused = false
	panel.visible = false
