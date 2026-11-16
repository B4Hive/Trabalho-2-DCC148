extends Control

@export var players:Array[Node]
@onready var camera = $Camera2D
@onready var turnLabel = $CanvasLayer/HUD/TurnLabel
@onready var skipButton = $CanvasLayer/HUD/SkipButton

var turn:int = 0
var currentPlayer:Node

func _ready() -> void:
	_on_end_turn()

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_end_turn() -> void:
	turnLabel.text = "Turn: " + String.num_int64(turn+1)
	currentPlayer = players[turn%2]
	currentPlayer.play()
	#TODO: Check endGame conditions
	turn+=1

func _on_skip_button_pressed() -> void:
	currentPlayer.endPhase.emit()

func setSkipButtonLabel(text:String)->void:
	skipButton.text = text
	skipButton.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
