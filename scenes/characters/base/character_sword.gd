extends CharacterBase

func _ready() -> void:
	hp = 4
	energy = 0
	unitRange = 0
	damage = 1
	specialCost = 3
	updateHUD()
