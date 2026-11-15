extends CharacterBody2D

var sprite:Node
var path:String = "res://scenes/characters/"
var file:String = "/sword_sprite.tscn"

func setSprite(team:String):
	sprite = load(path + team + file).instantiate()
	add_child(sprite)
