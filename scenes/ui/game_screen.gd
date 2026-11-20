extends Control

@export var players:Array[Node]
@onready var camera = $Camera2D
@onready var turnLabel = $CanvasLayer/HUD/TurnLabel
@onready var skipButton = $CanvasLayer/HUD/SkipButton
@onready var swordButton:Button = $CanvasLayer/HUD/SummonOptions/SwordButton
@onready var bowButton:Button = $CanvasLayer/HUD/SummonOptions/BowButton
@onready var mageButton:Button = $CanvasLayer/HUD/SummonOptions/MageButton

var turn:int = 0
var currentPlayer:Node

func _ready() -> void:
	_on_end_turn()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"): _on_up_pressed()
	if Input.is_action_just_pressed("ui_down"): _on_down_pressed()
	if Input.is_action_just_pressed("ui_left"): _on_left_pressed()
	if Input.is_action_just_pressed("ui_right"): _on_right_pressed()
	if Input.is_action_just_pressed("ui_accept"): _on_skip_button_pressed()
	if Input.is_action_just_pressed("ui_cancel"): _on_quit_button_pressed()
	if Input.is_action_just_pressed("ui_sword"): _on_sword_button_pressed()
	if Input.is_action_just_pressed("ui_bow"): _on_bow_button_pressed()
	if Input.is_action_just_pressed("ui_mage"): _on_mage_button_pressed()
	pass

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_end_turn() -> void:
	turnLabel.text = "Turn: " + String.num_int64(turn+1)
	currentPlayer = players[turn%2]
	swordButton.text = "1 - Sword (" + str(currentPlayer.summonCosts[0]) + ")"
	bowButton.text = "2 - Bow (" + str(currentPlayer.summonCosts[1]) + ")"
	mageButton.text = "3 - Mage (" + str(currentPlayer.summonCosts[2]) + ")"
	currentPlayer.play()
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

func endGame(victory:bool)->void:
	if victory: get_tree().change_scene_to_file("res://scenes/ui/victory_screen.tscn")
	else: get_tree().change_scene_to_file("res://scenes/ui/defeat_screen.tscn")

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
