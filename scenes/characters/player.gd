extends Node2D

@export var ai:bool
var team:String
var units:Array[CharacterBase]
var summonCosts:Array[int] = [3, 6, 9]


@onready var camera:Camera2D = $"../Camera2D"
@onready var summonOptions:VBoxContainer = $"../CanvasLayer/HUD/SummonOptions"
@onready var skipButton:Button = $"../CanvasLayer/HUD/SkipButton"
@onready var directionButtons:HBoxContainer = $"../CanvasLayer/HUD/DirectionButtons"
@onready var tower:CharacterBase = $CharacterTower
@onready var tilemap:TileMapLayer = $"../TileMap/TileMapLayer"

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
	tower.global_position = snapToTileGrid(tower.global_position)

func snapToTileGrid(worldPosition:Vector2)->Vector2:
	var size:Vector2 = tileSize()
	var gridOrigin:Vector2 = tilemap.map_to_local(Vector2i.ZERO) - size / 2.0
	var localPosition:Vector2 = tilemap.to_local(worldPosition)
	return tilemap.to_global(gridOrigin + (localPosition - gridOrigin).snapped(size))

func unitStep()->Vector2: return tileSize() * 2.0

func tileSize()->Vector2: return tilemap.tile_set.tile_size

func isAlive()->bool: return (tower.hp > 0)

func endTurn()->void:
	var towerEnergy:int = 6
	for unit in units:
		unit.gainEnergy(1)
		towerEnergy -= 1
	if towerEnergy < 0: towerEnergy = 0
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
		get_parent().setSkipButtonLabel(" Skip Action ")
		await movePhase(unit)
	get_parent().setSkipButtonLabel(" End Turn ")

func summonPhase()->void:
	summonOptions.show()
	var towerStep:Vector2 = tileSize() * 4.0
	var forwardDirection:float = -1.0 if tower.facingLeft else 1.0
	var offsets: Array[Vector2] = [
		Vector2((towerStep.x - tileSize().x) * forwardDirection, 0), # Direita
		Vector2(tileSize().x * forwardDirection, towerStep.y), # Baixo
		Vector2(tileSize().x * forwardDirection, -towerStep.y) # Cima
	]
	while tower.energy >= summonCosts.min() and amountOfFreeSlots(tower, offsets) > 0:
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
	if type == "none": return
	var cost: int = getSummonCost(type)
	if cost > 0 and tower.energy >= cost:
		tower.spendEnergy(cost)
		for offset in offsets:
			var pos = snapToTileGrid(tower.global_position + offset)
			if isPositionFree(pos):
				await createUnit(type, pos)
				break

func getSummonCost(type:String)->int:
	match type:
		"sword": return summonCosts[0]
		"bow": return summonCosts[1]
		"regular": return summonCosts[2]
	return 0

func createUnit(type:String, pos:Vector2)->void:
	tower.sprite.play("special")
	tower.specialAudio.play()
	await tower.sprite.animation_finished
	var unit:CharacterBody2D = load(characterPath + type + sceneFileType).instantiate()
	add_child(unit)
	unit.setSprite(team, type, self)
	if tower.facingLeft: unit.flipSprite()
	units.append(unit)
	unit.global_position = snapToTileGrid(pos)

func movePhase(unit:CharacterBase)->void:
	directionButtons.show()
	var step:Vector2 = unitStep()
	var offsets:Array[Vector2] = [
		Vector2(0, -step.y), #UP
		Vector2(step.x, 0), #RIGHT
		Vector2(0, step.y), #DOWN
		Vector2(-step.x, 0) #LEFT
	]
	while true:
		var dir:int = await direction
		if dir == -1: break
		if dir >= 0 and dir < offsets.size():
			for distance in range(1, unit.unitRange + 2):
				var target:CharacterBody2D = getBodyAt(unit.global_position + offsets[dir] * distance)
				if target is CharacterBase and target.team != team:
					directionButtons.hide()
					camera.setTarget(target)
					await unit.attack(target)
					return
			var destination:Vector2 = snapToTileGrid(unit.global_position + offsets[dir])
			if isPositionFree(destination):
				directionButtons.hide()
				await unit.moveTo(destination)
				break
	directionButtons.hide()

func gainEnergy(g:int)->void: tower.gainEnergy(g)

func removeUnit(unit:CharacterBase)->void:
	units.pop_at(units.find(unit))
	unit.queue_free()

func aiTurn()->void:
	skipButton.hide()
	await get_tree().create_timer(1.0, true, false, true).timeout
	await aiSummon()
	await get_tree().create_timer(0.5, true, false, true).timeout
	for unit in units:
		camera.setTarget(unit)
		await get_tree().create_timer(0.5, true, false, true).timeout
		var target:CharacterBase = nearestEnemyInRange(unit)
		if target != null:
			camera.setTarget(target)
			await unit.attack(target)
		else:
			await aiMove(unit)
		await get_tree().create_timer(0.5, true, false, true).timeout
	await get_tree().create_timer(0.5, true, false, true).timeout
	skipButton.show()

func aiSummon()->void:
	var towerStep:Vector2 = tileSize() * 4.0
	var forwardDirection:float = -1.0 if tower.facingLeft else 1.0
	var offsets: Array[Vector2] = [
		Vector2((towerStep.x - tileSize().x) * forwardDirection, 0), # Direita
		Vector2(tileSize().x * forwardDirection, towerStep.y), # Baixo
		Vector2(tileSize().x * forwardDirection, -towerStep.y) # Cima
	]
	while tower.energy >= summonCosts.min() and amountOfFreeSlots(tower, offsets) > 0:
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
	var stepSize:Vector2 = unitStep()
	if not is_zero_approx(delta.x):
		steps.append(Vector2(signf(delta.x) * stepSize.x, 0))
	if not is_zero_approx(delta.y):
		steps.append(Vector2(0, signf(delta.y) * stepSize.y))
	for step in steps:
		var destination:Vector2 = snapToTileGrid(unit.global_position + step)
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

func nearestEnemyInRange(unit:CharacterBase)->CharacterBase:
	var step:Vector2 = unitStep()
	var offsets:Array[Vector2] = [
		Vector2(0, -step.y), #UP
		Vector2(step.x, 0), #RIGHT
		Vector2(0, step.y), #DOWN
		Vector2(-step.x, 0) #LEFT
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
	return nearest

func gameLost()->void:
	get_parent().endGame(ai)
