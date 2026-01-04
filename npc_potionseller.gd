extends CharacterBody2D

@onready var interaction_area = $NpcInteractionArea
@onready var player: CharacterBody2D = $"../CharacterBody2D"

func _ready() -> void:
	$stan2.play("stan")
