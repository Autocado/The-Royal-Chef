extends CharacterBody2D

@onready var dialogue = $dialogue
@onready var interaction_area = $NpcInteractionArea
@onready var player: CharacterBody2D = $"../CharacterBody2D"

var player_in_range := false
var player_frozen := false

func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)
	dialogue.dialogue_finished.connect(_on_dialogue_dialogue_finished)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("chat"):
		single.emit_signal("Freeze",Callable())
		freeze_player()
		dialogue.start()

func _on_interaction_body_entered(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = true

func _on_interaction_body_exited(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = false


func freeze_player():
	if player and not player_frozen:
		player.set_physics_process(false)
		player.set_process_input(false)
		player_frozen = true

func unfreeze_player():
	if player and player_frozen:
		player.set_physics_process(true)
		player.set_process_input(true)
		player_frozen = false

func _on_dialogue_dialogue_finished() -> void:
	unfreeze_player()
	single.emit_signal("unFreeze")
