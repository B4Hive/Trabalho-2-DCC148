extends Control

var enableInput:bool = false
var scrollStep:float = 0
@onready var scrollContainer: ScrollContainer = $ScrollContainer

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	enableInput = true

func _process(delta: float) -> void:
	scrollStep += 100 * delta
	if scrollStep > 1:
		scrollContainer.scroll_vertical += 1
		scrollStep = 0
	if scrollContainer.scroll_vertical >= scrollContainer.get_v_scroll_bar().max_value - scrollContainer.get_v_scroll_bar().page:
		get_tree().quit()
	if Input.is_anything_pressed() and enableInput:
		get_tree().quit()
