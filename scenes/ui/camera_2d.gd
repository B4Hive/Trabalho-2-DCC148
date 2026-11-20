extends Camera2D

var target:Node
var speed:int = 5
func setTarget(newTarget:Node)->void: target = newTarget

func _process(delta: float) -> void:
	var target_pos = position
	if Input.is_action_pressed("shift"):
		var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if dir != Vector2.ZERO: target_pos += dir * delta * speed * 1000
	elif target == null: target_pos = Vector2.ZERO
	else: target_pos = target.global_position
	target_pos.x = clamp(target_pos.x, limit_left, limit_right)
	target_pos.y = clamp(target_pos.y, limit_top, limit_bottom)
	position = position.lerp(target_pos, minf(delta * speed, 1.0))
	position.x = clamp(position.x, limit_left, limit_right)
	position.y = clamp(position.y, limit_top, limit_bottom)
