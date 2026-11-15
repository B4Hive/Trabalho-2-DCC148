extends Control

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	get_tree().quit()

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().quit()
