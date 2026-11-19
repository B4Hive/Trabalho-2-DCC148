extends CharacterBase

func _ready() -> void:
	hp = 3
	energy = 0
	unitRange = 1
	damage = 3
	specialCost = 6
	updateHUD()
