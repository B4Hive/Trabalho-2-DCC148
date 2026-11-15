extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_on_exit_button_pressed()
	if Input.is_action_just_pressed("ui_accept"):
		_on_start_button_pressed()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits_screen.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/game_screen.tscn")
