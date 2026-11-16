extends Node2D

@export var ai:bool
var team:String
var units:Array[Node2D]

@onready var camera:Node = $"../Camera2D"

var active:bool = false
signal endTurnSignal

func _ready() -> void:
	if ai: team = "dude"
	else: team = "pink"
	$CharacterTower.setSprite(team)
	if ai: $CharacterTower.flipSprite()

func _process(delta: float) -> void:
	if active and Input.is_action_just_pressed("ui_accept"):
		await get_tree().create_timer(0.5).timeout
		endTurn()

func play()->void:
	active = true
	camera.setTarget(self)
	#TODO: Player Actions
	#TODO: Enemy AI

func endTurn()->void:
	active = false
	emit_signal("endTurnSignal")

func summonUnit(type:String)->void:
	print(type)
