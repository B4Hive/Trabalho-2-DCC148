class_name CharacterBase
extends CharacterBody2D

var sprite:AnimatedSprite2D
var spritePath:String = "res://scenes/characters/"
var spriteFile:String = "_sprite.tscn"

var team:String
var player:Node2D

var facingLeft:bool = false
@onready var collisionBox:CollisionShape2D = $CollisionShape2D
@onready var particle:Node2D = $HUD/ParticleSystem
@onready var hurtAudio:AudioStreamPlayer = $HUD/AudioManager/Hurt
@onready var specialAudio:AudioStreamPlayer = $HUD/AudioManager/Special
@onready var attackAudio:AudioStreamPlayer = $HUD/AudioManager/Attack
@onready var deathAudio:AudioStreamPlayer = $HUD/AudioManager/Death

var hp:int
var energy:int
var unitRange:int
var damage:int
var specialCost:int
@onready var hud:HUD = $HUD

signal movementFinished
var moveSpeed:float = 32
var moveTarget:Vector2
var moving:bool = false

func _process(_delta: float) -> void:
	if sprite != null and not sprite.is_playing():
		sprite.play("idle")

func setSprite(unitTeam:String, spriteType:String, unitPlayer:Node2D):
	team = unitTeam
	var path:String = spritePath + team + "/" + spriteType + spriteFile
	sprite = load(path).instantiate()
	add_child(sprite)
	move_child(sprite, 1)
	player = unitPlayer

func _physics_process(delta: float) -> void:
	if moving:
		var remaining: Vector2 = moveTarget - global_position
		if remaining.length() <= moveSpeed * delta:
			global_position = moveTarget
			velocity = Vector2.ZERO
			moving = false
			if sprite != null:
				sprite.play("idle")
			movementFinished.emit()
			return
		velocity = remaining.normalized() * moveSpeed
		move_and_slide()
		if get_slide_collision_count() > 0:
			velocity = Vector2.ZERO
			moving = false
			if sprite != null:
				sprite.play("idle")
			movementFinished.emit()

@warning_ignore("integer_division")
func updateHUD()->void: hud.update(hp, (energy*100/specialCost))

func flipSprite()->void:
	if facingLeft:
		sprite.flip_h = false
		sprite.position.x *= -1
		facingLeft = false
		collisionBox.position.x *= -1
	else:
		sprite.flip_h = true
		sprite.position.x *= -1
		facingLeft = true
		collisionBox.position.x *= -1

func takeDamage(dmg:int)->void:
	particle.play("damage")
	sprite.play("hurt")
	hurtAudio.play()
	await sprite.animation_finished
	hp -= dmg
	updateHUD()
	if hp <= 0:
		await die()

func die()->void:
	sprite.play("death")
	deathAudio.play()
	await sprite.animation_finished
	player.removeUnit(self)

func healHP(amount:int)->void:
	particle.play("healing")
	if hp + amount <= 6: hp += amount
	else: hp = 6
	updateHUD()

func gainEnergy(e:int)->void:
	if e > 0: energy += e
	if energy >= specialCost:
		energy = specialCost
		particle.play("special")
	updateHUD()

func spendEnergy(e:int)->bool:
	if energy >= e and e > 0:
		energy -= e
		particle.stop()
		updateHUD()
		return true
	return false

func moveTo(targetPos:Vector2)->void:
	moveTarget = targetPos
	moving = true
	if sprite != null:
		sprite.play("walk")
		# Flip depending on direction
	await movementFinished

func attack(target:CharacterBase):
	var dmg = 1
	if spendEnergy(specialCost):
		dmg = special()
		sprite.play("special")
		specialAudio.play()
		await sprite.animation_finished
	else:
		sprite.play("attack")
		attackAudio.play()
		await sprite.animation_finished
	player.camera.setTarget(target)
	await target.takeDamage(dmg)

func special()->int:
	return damage
