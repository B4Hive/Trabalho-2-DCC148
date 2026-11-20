extends CharacterBase

func _ready() -> void:
	hp = 2
	energy = 0
	unitRange = 2
	damage = 2
	specialCost = 2
	updateHUD()
