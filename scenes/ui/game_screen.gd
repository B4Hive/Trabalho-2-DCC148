extends Control

@export var players:Array[Node]
@onready var camera = $Camera2D
@onready var turnLabel = $CanvasLayer/HUD/TurnLabel

var turn:int = 0

func _ready() -> void:
	_on_end_turn()

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_end_turn() -> void:
	turnLabel.text = "Turn: " + String.num_int64(turn+1)
	var currentPlayer = players[turn%2]
	currentPlayer.play()
	#TODO: Check endGame conditions
	turn+=1
