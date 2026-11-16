extends CharacterBody2D

var sprite:AnimatedSprite2D
var path:String = "res://scenes/characters/"
var file:String = "/bow_sprite.tscn"

func setSprite(team:String):
	sprite = load(path + team + file).instantiate()
	add_child(sprite)
