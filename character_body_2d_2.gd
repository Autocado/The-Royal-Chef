extends CharacterBody2D
@onready var dialogue = $dialogue
@onready var player = $CharacterBody2D
# Called when the node enters the scene tree for the first time.
	


func _on_dialogue_dialogue_finished() -> void:
	pass # Replace with function body.


	if Input.is_action_just_pressed("chat"):
		dialogue.start()
