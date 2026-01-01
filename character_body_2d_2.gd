extends CharacterBody2D

@onready var dialogue = $dialogue
@onready var interaction_area = $NpcInteractionArea

var player_in_range := false

func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("chat"):
		single.emit_signal("Freeze",Callable())
		dialogue.start()
		FreezePlayer()

func _on_interaction_body_entered(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = true

func _on_interaction_body_exited(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = false


func FreezePlayer():
	if single.connect("Freeze",Callable()):
			var player =$"../CharacterBody2D"
			player.set_physics_process(false)
			player.set_process_input(false)
func walk_again():
	if single.connect("unFreeze",Callable()):
		var player =$"../CharacterBody2D"
		player.set_physics_process(true)
		player.set_process_input(true)

func _on_dialogue_dialogue_finished() -> void:
	pass # Replace with function body.
