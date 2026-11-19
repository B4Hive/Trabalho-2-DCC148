extends Node2D

@onready var damage:CPUParticles2D = $Damage
@onready var healing:CPUParticles2D = $Healing
@onready var special:CPUParticles2D = $Special

func _ready() -> void:
	for child in get_children():
		child.show()
		child.emitting = false

func play(anim:String)->void:
	if anim == "damage": damage.emitting = true
	if anim == "healing": healing.emitting = true
	if anim == "special": special.emitting = true

func stop()->void:
	for child in get_children():
		child.emitting = false
