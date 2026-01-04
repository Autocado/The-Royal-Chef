extends CharacterBody2D

@onready var interaction_area = $NpcInteractionArea
@onready var player: CharacterBody2D = $"../CharacterBody2D"
@onready var animated_npcsell = $sell/stan

func _ready() -> void:
	$stan.play("npc_sell")
