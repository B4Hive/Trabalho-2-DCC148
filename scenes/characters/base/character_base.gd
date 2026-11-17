class_name CharacterBase
extends CharacterBody2D

var sprite:AnimatedSprite2D
var spritePath:String = "res://scenes/characters/"
var spriteFile:String = "_sprite.tscn"

var facingLeft:bool = false

var hp : int
@onready var hpLabel:Label = $HUD/HP
var energy : int
@onready var energyLabel:Label = $HUD/Energy

func _process(_delta: float) -> void:
	if sprite != null and not sprite.is_playing():
		sprite.play("idle")

func setSprite(team:String, type:String):
	var path:String = spritePath + team + "/" + type + spriteFile
	sprite = load(path).instantiate()
	add_child(sprite)

func updateHUD()->void:
	hpLabel.text = String.num_int64(hp)
	energyLabel.text = String.num_int64(energy)

func flipSprite()->void:
	if facingLeft:
		sprite.flip_h = false
		facingLeft = false
	else:
		sprite.flip_h = true
		facingLeft = true

func takeDamage(dmg:int)->void:
	if hp > dmg and dmg > 0: hp -= dmg
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
