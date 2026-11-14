extends Camera2D

@export var speed: float
func _process(delta: float) -> void:
	var dy = Input.get_axis("ui_up", "ui_down")
	var dx = Input.get_axis("ui_left", "ui_right")
	
	translate(speed * delta * Vector2(dx,dy))
