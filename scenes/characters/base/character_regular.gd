extends CharacterBase

func _ready() -> void:
	hp = 3
	energy = 0
	unitRange = 1
	damage = 1
	specialCost = 4
	updateHUD()

func special()->int:
	damage += 1
	specialCost = damage * 2
	return damage
