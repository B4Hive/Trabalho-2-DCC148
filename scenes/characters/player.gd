extends Node2D

@export var ai:bool
var team:String
var units:Array[CharacterBody2D]

@onready var camera:Camera2D = $"../Camera2D"
@onready var tower:CharacterBody2D = $CharacterTower

var active:bool = false
signal endTurnSignal
signal endPhase

func _ready() -> void:
	if ai: team = "dude"
	else: team = "pink"
	tower.setSprite(team)
	if ai: tower.flipSprite()

func _process(_delta: float) -> void:
	pass

func endTurn()->void:
	active = false
	emit_signal("endTurnSignal")

func play()->void:
	active = true
	camera.setTarget(tower)
	#TODO: Player Actions & Enemy AI
	summonPhase()
	await endPhase
	$"../CanvasLayer/HUD/SummonOptions".hide()
	#2 - Control Units
	for unit in units:
		camera.setTarget(unit)
		get_parent().setSkipButtonLabel(" Skip Move ")
		#2.1 - Move Unit
			#AI: scan surroundings
			#AI: goto nearest target direction
			#Player: selecionar direcao
		await endPhase
		get_parent().setSkipButtonLabel(" Skip Attack ")
		#2.2 - Attack
			#AI: if scansurroundings has enemy on range
			#Player: select direction to attack
				#attack
				#if enemy dies
					#gain gold
		await endPhase
	get_parent().setSkipButtonLabel(" End Turn ")
	await endPhase
	endTurn()

func summonPhase()->void:
	var _amountOfUnitsSummoned:int = 0
	get_parent().setSkipButtonLabel(" Skip Summon ")
	$"../CanvasLayer/HUD/SummonOptions".show()
	#while tower.gold > 0 and amountOfUnitsSummoned < 3:
		#summonUnit after receiving the signal to the unit type or end summon phase on signal
		#if gold >= minimo de custo de unidade
			#selecionar unidade a ser comprada
			#selecionar posicionamento (adjacente à torre ou como upgrade de outra unidade)
			#posicionar/upgrade unidade
	#endPhase.emit()

func slotFreeForSummon()->bool:
	#TODO:verify tiles around tower and check for units there
	return false

func summonUnit(type:String)->void:
	if not slotFreeForSummon():
		return
	print(type)
	#TODO: while gold>x and unitsSummonedThisTurn < 3 and freeSummonPosition: instantiate; append to array; add as child; position;

func gainGold(g:int)->void:
	tower.gainGold(g)

func removeUnit(unit:CharacterBody2D)->void:
	print(unit) # idk if that'll work from here...
