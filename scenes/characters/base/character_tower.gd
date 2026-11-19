extends CharacterBase

func _ready() -> void:
	hp = 6
	energy = 6
	unitRange = 0
	updateHUD()

func setSprite(t:String, type:String):
	team = t
	var path:String = spritePath + team + "/" + type + spriteFile
	sprite = load(path).instantiate()
	add_child(sprite)
	sprite.scale *= 2

func takeDamage(dmg:int)->void:
	@warning_ignore("integer_division")
	hp -= dmg/dmg
	updateHUD()
