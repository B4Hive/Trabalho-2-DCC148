extends CharacterBody2D

var sprite:Node
var path:String = "res://scenes/characters/"
var file:String = "/regular_sprite.tscn"
var facingLeft:bool

var hp : int
@onready var hpLabel:Label = $HUD/HP
var gold : int
@onready var goldLabel:Label = $HUD/Gold

func _ready() -> void:
	hp = 10
	gold = 0
	hpLabel.text = String.num_int64(hp)
	goldLabel.text = String.num_int64(gold)

func setSprite(team:String):
	sprite = load(path + team + file).instantiate()
	add_child(sprite)
	sprite.scale *= 2

func flipSprite()->void:
	if facingLeft:
		sprite.flip_h = false
		facingLeft = false
	else:
		sprite.flip_h = true
		facingLeft = true
