extends CharacterBase

func _ready() -> void:
	hp = 4
	energy = 0
	unitRange = 0
	damage = 2
	specialCost = 3
	updateHUD()

func special()->int:
	healHP(damage)
	return damage
