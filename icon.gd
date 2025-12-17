extends Node2D
@onready var animated_sprite_2d = $CharacterBody2D/idle
@onready var animated_npc = $CharacterBody2D2/Nidle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("white")
	animated_npc.play("npc")
	
	if $CharacterBody2D2.position.y < $CharacterBody2D.position.y:
		$CharacterBody2D2.z_index = 1
	else:
		$CharacterBody2D.z_index = 2
