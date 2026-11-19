class_name CharacterBase
extends CharacterBody2D

var sprite:AnimatedSprite2D
var spritePath:String = "res://scenes/characters/"
var spriteFile:String = "_sprite.tscn"

var team:String

var facingLeft:bool = false
@onready var collisionBox:CollisionShape2D = $CollisionShape2D

var hp:int
var energy:int
var unitRange:int
@onready var hud:Control = $HUD

signal movementFinished
var moveSpeed:float = 16
var moveTarget:Vector2
var moving:bool = false

func _process(_delta: float) -> void:
	if sprite != null and not sprite.is_playing():
		sprite.play("idle")

func setSprite(t:String, type:String):
	team = t
	var path:String = spritePath + team + "/" + type + spriteFile
	sprite = load(path).instantiate()
	add_child(sprite)

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

func updateHUD()->void: hud.update(hp, energy)

func flipSprite()->void:
	if facingLeft:
		sprite.flip_h = false
		facingLeft = false
		collisionBox.position.x *= -1
	else:
		sprite.flip_h = true
		facingLeft = true
		collisionBox.position.x *= -1

func takeDamage(dmg:int)->void:
	hp -= dmg
	updateHUD()

func healHP(amount:int)->void:
	if hp + amount <= 6: hp += amount
	updateHUD()

func gainEnergy(e:int)->void:
	if e > 0: energy += e
	updateHUD()

func spendEnergy(e:int)->bool:
	if energy >= e and e > 0:
		energy -= e
		updateHUD()
		return true
	return false

func moveTo(targetPos:Vector2)->void:
	moveTarget = targetPos
	moving = true
	if sprite != null:
		sprite.play("walk")
	await movementFinished
