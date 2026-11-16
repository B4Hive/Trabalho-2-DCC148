extends Camera2D

var target : Node

func setTarget(newTarget:Node)->void:
	target = newTarget

func _process(delta: float) -> void:
	var target_pos = position
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir != Vector2.ZERO:
		target_pos += dir * delta * 10000
	elif target == null:
		target_pos = Vector2.ZERO
	else:
		target_pos = target.position
	position = position.lerp(target_pos, delta)
	position.x = clamp(position.x, limit_left, limit_right)
	position.y = clamp(position.y, limit_top, limit_bottom)
