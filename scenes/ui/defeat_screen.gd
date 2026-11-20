extends Control

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
