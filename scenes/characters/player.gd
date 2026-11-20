extends Node2D

@export var ai:bool
var team:String
var units:Array[CharacterBase]

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
	tower.setSprite(team,"regular", self)
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
	if type == "sword": cost = 3
	elif type == "bow": cost = 6
	elif type == "regular": cost = 9
	elif type == "none": return
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
	unit.setSprite(team, type, self)
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
						await unit.attack(target)
						return
	directionButtons.hide()

func gainEnergy(g:int)->void: tower.gainEnergy(g)

func removeUnit(unit:CharacterBase)->void:
	units.pop_at(units.find(unit))
	unit.queue_free()

func aiTurn()->void:
	skipButton.hide()
	await get_tree().create_timer(2.0, true, false, true).timeout
	await aiSummon()
	for unit in units:
		await get_tree().create_timer(1.0, true, false, true).timeout
		await aiMove(unit)
		await get_tree().create_timer(1.0, true, false, true).timeout
		await aiAttack(unit)
	await get_tree().create_timer(1.0, true, false, true).timeout
	skipButton.show()

func aiSummon()->void:
	var offsets: Array[Vector2] = [
		Vector2(64, 0), # Direita
		Vector2(0, 64), # Baixo
		Vector2(0, -64) # Cima
	]
	if tower.facingLeft: offsets[0] *= -1
	while tower.energy > 0 and amountOfFreeSlots(tower, offsets) > 0:
		var unitTypes:Array[String] = [
			"sword",
			"bow",
			"regular",
			"none"
		]
		var type = unitTypes.pick_random()
		if type == "none": return
		await summonUnit(type, offsets)
		await get_tree().create_timer(1.0, true, false, true).timeout

func aiMove(unit:CharacterBase)->void:
	camera.setTarget(unit)
	await get_tree().create_timer(1.0, true, false, true).timeout
	var targetPos:Vector2 = nearestEnemy(unit)
	var delta:Vector2 = targetPos - unit.global_position
	var steps:Array[Vector2] = []
	if not is_zero_approx(delta.x):
		steps.append(Vector2(signf(delta.x) * 32, 0))
	if not is_zero_approx(delta.y):
		steps.append(Vector2(0, signf(delta.y) * 32))
	for step in steps:
		var destination:Vector2 = unit.global_position + step
		if isPositionFree(destination):
			await unit.moveTo(destination)
			break

func nearestEnemy(unit:CharacterBase)->Vector2:
	var nearest:CharacterBase = null
	var nearestDistanceSquared:float = INF
	for target in get_tree().current_scene.find_children("*", "CharacterBody2D", true, false):
		if target is CharacterBase and target.team != unit.team:
			var distanceSquared:float = unit.global_position.distance_squared_to(target.global_position)
			if distanceSquared < nearestDistanceSquared:
				nearest = target
				nearestDistanceSquared = distanceSquared
	if nearest != null:
		return nearest.global_position
	return unit.global_position

func aiAttack(unit:CharacterBase)->void:
	var offsets:Array[Vector2] = [
		Vector2(0, -32), #UP
		Vector2(32, 0), #RIGHT
		Vector2(0, 32), #DOWN
		Vector2(-32, 0) #LEFT
	]
	var nearest:CharacterBase = null
	var nearestDistanceSquared:float = INF
	for offset in offsets:
		for d in range(1, unit.unitRange + 2):
			var targetPos:Vector2 = unit.global_position + offset * d
			var target:CharacterBody2D = getBodyAt(targetPos)
			if target is CharacterBase and target.team != unit.team:
				var distanceSquared:float = unit.global_position.distance_squared_to(target.global_position)
				if distanceSquared < nearestDistanceSquared:
					nearest = target
					nearestDistanceSquared = distanceSquared
	if nearest != null:
		await unit.attack(nearest)
	await get_tree().create_timer(1.0, true, false, true).timeout
