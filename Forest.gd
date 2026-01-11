extends Area2D


var entered = false
func _on_body_entered(body: PhysicsBody2D):
	entered = true

func _on_body_exited(body):
	entered = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		var actionable = $".".get_overlapping_areas()
		if actionable.size() > 0:
			get_tree().change_scene_to_file("res://forest.tscn")
