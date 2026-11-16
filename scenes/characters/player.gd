extends Node2D

@export var ai:bool
var team:String
var units:Array[Node2D]

@onready var camera:Node = $"../Camera2D"
@onready var tower:CharacterBody2D = $CharacterTower

var active:bool = false
signal endTurnSignal

func _ready() -> void:
	if ai: team = "dude"
	else: team = "pink"
	tower.setSprite(team)
	if ai: tower.flipSprite()

func _process(_delta: float) -> void:
	if active and Input.is_action_just_pressed("ui_accept"):
		await get_tree().create_timer(0.5).timeout
		endTurn()

func play()->void:
	active = true
	camera.setTarget(self)
	#TODO: Player Actions & Enemy AI
	#1 - Summon Units
	#if gold >= minimo de custo de unidade
		#selecionar unidade a ser comprada
		#selecionar posicionamento (adjacente à torre ou como upgrade de outra unidade)
		#posicionar/upgrade unidade
	#2 - Control Units
	#for unit:units
	#2.1 - Move Unit
		#AI: scan surroundings
		#AI: goto nearest target direction
		#Player: selecionar direcao
	#2.2 - Attack
		#AI: if scansurroundings has enemy on range
		#Player: select direction to attack
			#attack
			#if enemy dies
				#gain gold
	#3 - End Turn

func endTurn()->void:
	active = false
	emit_signal("endTurnSignal")

func summonUnit(type:String)->void:
	print(type)
