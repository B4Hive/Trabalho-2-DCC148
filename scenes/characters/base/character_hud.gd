class_name HUD
extends Control

@export var sprites:Array[Texture2D]

func update(hp:int, energy:int)->void:
	$Control/HP.texture = sprites[clamp(hp,0,6)]
	$Control/HP.show()
	$Energy.text = String.num_int64(energy)
