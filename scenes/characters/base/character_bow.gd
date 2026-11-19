extends CharacterBase

func _ready() -> void:
	hp = 2
	energy = 0
	unitRange = 3
	damage = 2
	specialCost = 3
	updateHUD()
