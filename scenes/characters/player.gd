extends Node2D

@export var ai:bool
var team:String
var units:Array[CharacterBody2D]

@onready var camera:Camera2D = $"../Camera2D"
@onready var tower:CharacterBody2D = $CharacterTower

var characterPath:String = "res://scenes/characters/base/character_"
var sceneFileType:String = ".tscn"

var active:bool = false
signal endTurnSignal
signal endPhase
signal summon()

func _ready() -> void:
	if ai: team = "dude"
	else: team = "pink"
	tower.setSprite(team,"regular")
	if ai: tower.flipSprite()

func isAlive()->bool: return (tower.hp > 0)

func endTurn()->void:
	active = false
	endTurnSignal.emit()

func play()->void:
	active = true
	camera.setTarget(tower)
	summonPhase()
	await endPhase
	for unit in units:
		camera.setTarget(unit)
		get_parent().setSkipButtonLabel(" End Move ")
		movePhase(unit)
		await endPhase
		get_parent().setSkipButtonLabel(" End Attack ")
		attackPhase(unit)
		await endPhase
	get_parent().setSkipButtonLabel(" End Turn ")
	await endPhase
	endTurn()

func summonPhase()->void:
	get_parent().setSkipButtonLabel(" End Summon ")
	$"../CanvasLayer/HUD/SummonOptions".show()
	while tower.energy > 0 and slotFreeForSummon() > 0:
		if tower.energy == 0 or slotFreeForSummon() == 0:
			endPhase.emit()
			break
		print($"../CanvasLayer/HUD/SkipButton".text)
		var type:String = await summon
		if type == "none":
			endPhase.emit()
			break
		summonUnit(type)
	$"../CanvasLayer/HUD/SummonOptions".hide()

#TODO: generalizar esse método pra receber o ponto de referencia ao invés de só usar a torre
func slotFreeForSummon() -> int:
	var slots: int = 0
	var slotList = [
		tower.global_position + Vector2(64, 0),   # x + 64 (Direita)
		tower.global_position + Vector2(0, 64),   # y + 64 (Baixo)
		tower.global_position + Vector2(0, -64)   # y - 64 (Cima)
	]
	#if tower is flipped, pos[0] *= -1
	var space_state = get_world_2d().direct_space_state
	for pos in slotList:
		var query = PhysicsPointQueryParameters2D.new()
		query.position = pos
		var result = space_state.intersect_point(query)
		if result.is_empty():
			slots += 1
	return slots

func summonUnit(type:String)->void:
	var cost:int = 0
	if type == "sword":
		cost = 1
	elif type == "bow":
		cost = 2
	elif type == "regular":
		cost = 3
	if cost > 0 and tower.energy >= cost:
		tower.spendEnergy(cost)
		var slotList = [
			tower.global_position + Vector2(64, 0),   # x + 64 (Direita)
			tower.global_position + Vector2(0, 64),   # y + 64 (Baixo)
			tower.global_position + Vector2(0, -64)   # y - 64 (Cima)
		]
		if tower.facingLeft: slotList[0] *= -1
		var space_state = get_world_2d().direct_space_state
		for pos in slotList:
			var query = PhysicsPointQueryParameters2D.new()
			query.position = pos
			var result = space_state.intersect_point(query)
			if result.is_empty():
				tower.sprite.play("special")
				await tower.sprite.animation_finished
				var unit:CharacterBody2D = load(characterPath + type + sceneFileType).instantiate()
				add_child(unit)
				unit.setSprite(team, type)
				#TODO: if tower is flipped: flipsprite
				units.append(unit)
				unit.position = to_local(pos)
				break

func movePhase(unit:CharacterBody2D)->void:
	print(unit)
	#TODO: movement here (wow i would have never guessed)
	#2.1 - Move Unit
			#AI: scan surroundings
			#AI: goto nearest target direction
			#Player: selecionar direcao
	await endPhase

func attackPhase(unit:CharacterBody2D)->void:
	print(unit)
	#TODO: attack here (wow i would have never guessed)
	#2.2 - Attack
			#AI: if scansurroundings has enemy on range
			#Player: select direction to attack
				#attack
				#if enemy dies
					#gain energy
	await endPhase

func gainEnergy(g:int)->void:
	tower.gainEnergy(g)

func removeUnit(unit:CharacterBody2D)->void:
	print(unit) # idk if that'll work from here...
