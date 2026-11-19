extends CharacterBase

func _ready() -> void:
	hp = 6
	energy = 3
	specialCost = INT64_MAX
	updateHUD()

func setSprite(t:String, type:String):
	team = t
	var path:String = spritePath + team + "/" + type + spriteFile
	sprite = load(path).instantiate()
	add_child(sprite)
	sprite.scale *= 2

func takeDamage(_dmg:int)->void:
	particle.play("damage")
	hp -= 1
	updateHUD()
