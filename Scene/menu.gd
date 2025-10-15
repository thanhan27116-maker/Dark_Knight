extends Control


func _ready() -> void:
	$menu_btn/exit_btn/Button.pressed.connect(_on_button_pressed)
		
func _on_button_pressed() -> void:
	print("thoat")
	get_tree().quit() 
