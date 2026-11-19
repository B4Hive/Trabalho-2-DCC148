extends Node2D

@export var ai:bool
var team:String
var units:Array[CharacterBody2D]

@onready var camera:Camera2D = $"../Camera2D"
@onready var summonOptions:HBoxContainer = $"../CanvasLayer/HUD/SummonOptions"
@onready var skipButton:Button = $"../CanvasLayer/HUD/SkipButton"
@onready var directionButtons:HBoxContainer = $"../CanvasLayer/HUD/DirectionButtons"
@onready var tower:CharacterBody2D = $CharacterTower

var characterPath:String = "res://scenes/characters/base/character_"
var sceneFileType:String = ".tscn"

signal endTurnSignal
signal summon(type:String)
signal direction(dir:int)

func _ready() -> void:
	if ai: team = "dude"
	else: team = "pink"
	tower.setSprite(team,"regular")
	if ai: tower.flipSprite()

func isAlive()->bool: return (tower.hp > 0)

func endTurn()->void:
	var towerEnergy:int = 1
	for unit in units:
		unit.gainEnergy(1)
		towerEnergy += 1
	tower.gainEnergy(towerEnergy)
	endTurnSignal.emit()

func play()->void:
	camera.setTarget(tower)
	if ai: await aiTurn()
	else: await playerTurn()
	endTurn()

func playerTurn()->void:
	get_parent().setSkipButtonLabel(" Skip Summon ")
	await summonPhase()
	for unit in units:
		camera.setTarget(unit)
		get_parent().setSkipButtonLabel(" Skip Move ")
		await movePhase(unit)
		get_parent().setSkipButtonLabel(" Skip Attack ")
		await attackPhase(unit)
	get_parent().setSkipButtonLabel(" End Turn ")

func aiTurn()->void:
	skipButton.hide()
	# TODO: omfg this will be hard...
	await get_tree().create_timer(2).timeout
	skipButton.show()

func summonPhase()->void:
	summonOptions.show()
	var offsets: Array[Vector2] = [
		Vector2(64, 0), # Direita
		Vector2(0, 64), # Baixo
		Vector2(0, -64) # Cima
	]
	if tower.facingLeft: offsets[0] *= -1
	while tower.energy > 0 and amountOfFreeSlots(tower, offsets) > 0:
		if tower.energy == 0 or amountOfFreeSlots(tower, offsets) == 0:
			break
		var type:String = await summon
		if type == "none":
			break
		summonOptions.hide()
		await summonUnit(type, offsets)
		if tower.energy > 0 and amountOfFreeSlots(tower, offsets) > 0:
			summonOptions.show()
	summonOptions.hide()

func amountOfFreeSlots(center: Node2D, positions: Array[Vector2]) -> int:
	var slots: int = 0
	for offset in positions:
		var pos = center.global_position + offset
		if isPositionFree(pos): slots += 1
	return slots

func isPositionFree(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	var result = space_state.intersect_point(query)
	return result.is_empty()

func getBodyAt(pos: Vector2) -> CharacterBody2D:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_bodies = true
	query.collide_with_areas = false
	var result = space_state.intersect_point(query)
	if result.is_empty():
		return null
	for hit in result:
		var collider = hit["collider"]
		if collider is CharacterBody2D:
			return collider
	return null

func summonUnit(type:String, offsets:Array[Vector2]) -> void:
	var cost: int = 0
	if type == "sword": cost = 1
	elif type == "bow": cost = 2
	elif type == "regular": cost = 3
	if cost > 0 and tower.energy >= cost:
		tower.spendEnergy(cost)
		for offset in offsets:
			var pos = tower.global_position + offset
			if isPositionFree(pos):
				await createUnit(type, pos)
				break

func createUnit(type:String, pos:Vector2)->void:
	tower.sprite.play("special")
	await tower.sprite.animation_finished
	var unit:CharacterBody2D = load(characterPath + type + sceneFileType).instantiate()
	add_child(unit)
	unit.setSprite(team, type)
	if tower.facingLeft: unit.flipSprite()
	units.append(unit)
	unit.position = to_local(pos)

func movePhase(unit:CharacterBody2D)->void:
	directionButtons.show()
	var offsets:Array[Vector2] = [
		Vector2(0, -32), #UP
		Vector2(32, 0), #RIGHT
		Vector2(0, 32), #DOWN
		Vector2(-32, 0) #LEFT
	]
	for i in range(4): offsets[i] += unit.global_position
	while true:
		var dir:int = await direction
		if dir == -1: break
		if dir >= 0 and dir < offsets.size() and isPositionFree(offsets[dir]):
			directionButtons.hide()
			await unit.moveTo(offsets[dir])
			break
	directionButtons.hide()

func attackPhase(unit:CharacterBody2D)->void:
	directionButtons.show()
	var offsets:Array[Vector2] = [
		Vector2(0, -32), #UP
		Vector2(32, 0), #RIGHT
		Vector2(0, 32), #DOWN
		Vector2(-32, 0) #LEFT
	]
	while true:
		var dir:int = await direction
		if dir == -1: break
		if dir >= 0 and dir < offsets.size():
			for d in range(1, unit.unitRange + 2):
				var targetPos = unit.global_position + offsets[dir] * d
				var target = getBodyAt(targetPos)
				if not target == null:
					if target.team != self.team:
						directionButtons.hide()
						unit.attack(target)
	directionButtons.hide()

func gainEnergy(g:int)->void: tower.gainEnergy(g)

func removeUnit(unit:CharacterBody2D)->void:
	print(unit) # idk if that'll work from here...
