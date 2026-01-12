extends Area2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		var actionable = $".".get_overlapping_areas()
		if actionable.size() > 0:
			get_tree().change_scene_to_file("res://palace.tscn")
