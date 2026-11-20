class_name HUD
extends Control

@export var sprites:Array[Texture2D]
var currentHP:int = 0

func update(hp:int, energy:int)->void:
	$Energy.text = String.num_int64(energy)
	hp = clamp(hp, 0, 6)
	while not currentHP == hp:
		if currentHP < hp: currentHP += 1
		else: currentHP -= 1
		$Control/HP.texture = sprites[currentHP]
		await get_tree().create_timer(0.25, true, false, true).timeout
