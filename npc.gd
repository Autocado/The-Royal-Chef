extends CharacterBody2D


func _ready() -> void:
	$Nidle.play("npc")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		var actionable = $NpcInteractionArea.get_overlapping_areas()
		if actionable.size() > 0:
			DialogueManager.show_dialogue_balloon(load("res://dialogue/first.dialogue"))
