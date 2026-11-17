extends CharacterBase

func _ready() -> void:
	hp = 10
	energy = 3
	updateHUD()

func setSprite(team:String, type:String):
	team = team
	type = type
	var path:String = spritePath + team + "/" + type + spriteFile
	sprite = load(path).instantiate()
	add_child(sprite)
	sprite.scale *= 2
	sprite.play("idle")
