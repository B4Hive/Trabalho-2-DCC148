extends Control

@export var players:Array[Node]
@onready var camera = $Camera2D
@onready var turnLabel = $CanvasLayer/HUD/TurnLabel
@onready var skipButton = $CanvasLayer/HUD/SkipButton

var turn:int = 0
var currentPlayer:Node

func _ready() -> void:
	_on_end_turn()

func _process(_delta: float) -> void:
	# Keyboard Controls
	pass

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_end_turn() -> void:
	turnLabel.text = "Turn: " + String.num_int64(turn+1)
	currentPlayer = players[turn%2]
	currentPlayer.play()
	if not currentPlayer.isAlive(): endGame()
	turn+=1

func _on_skip_button_pressed() -> void:
	if $CanvasLayer/HUD/SummonOptions.is_visible_in_tree():
		currentPlayer.summon.emit("none")
		return
	if $CanvasLayer/HUD/DirectionButtons.is_visible_in_tree():
		currentPlayer.direction.emit(-1)
		return

func setSkipButtonLabel(text:String)->void:
	skipButton.text = text
	skipButton.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)

func endGame()->void:
	#TODO: check which player won and go to the corresponding end screen
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_sword_button_pressed() -> void:
	currentPlayer.summon.emit("sword")

func _on_bow_button_pressed() -> void:
	currentPlayer.summon.emit("bow")

func _on_mage_button_pressed() -> void:
	currentPlayer.summon.emit("regular")

func _on_left_pressed() -> void:
	currentPlayer.direction.emit(3)

func _on_up_pressed() -> void:
	currentPlayer.direction.emit(0)

func _on_down_pressed() -> void:
	currentPlayer.direction.emit(2)

func _on_right_pressed() -> void:
	currentPlayer.direction.emit(1)
