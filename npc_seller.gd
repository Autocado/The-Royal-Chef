extends CharacterBody2D

@onready var interaction_area = $NpcInteractionArea
@onready var player: CharacterBody2D = $"../CharacterBody2D"
@onready var animated_npcsell = $sell/stan

func _ready() -> void:
	$stan.play("npc_sell")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		var actionable = $NpcInteractionArea.get_overlapping_areas()
		if actionable.size() > 0:
			DialogueManager.show_dialogue_balloon(load("res://dialogue/second.dialogue"))
