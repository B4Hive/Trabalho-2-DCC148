extends CharacterBase

func _ready() -> void:
	hp = 6
	energy = 18
	specialCost = INT64_MAX
	particle.position += Vector2(16,16)
	updateHUD()

func setSprite(unitTeam:String, spriteType:String, unitPlayer:Node2D):
	team = unitTeam
	var path:String = spritePath + team + "/" + spriteType + spriteFile
	sprite = load(path).instantiate()
	add_child(sprite)
	move_child(sprite, 1)
	player = unitPlayer
	sprite.scale *= 2

func updateHUD()->void: hud.update(hp, energy)

func takeDamage(_dmg:int)->void:
	particle.play("damage")
	sprite.play("hurt")
	await sprite.animation_finished
	if hp <= 0:
		await die()
		#endGame
	particle.play("damage")
	hp -= 1
	updateHUD()

func die()->void:
	sprite.play("death")
	await sprite.animation_finished
	player.removeUnit(self)
	player.gameLost()
