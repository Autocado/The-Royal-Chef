extends CharacterBody2D

@onready var dialogue = $dialogue
@onready var interaction_area = $NpcInteractionArea

var player_in_range := false
var dialogue_active := false

func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)
	dialogue.dialogue_finished.connect(_on_dialogue_dialogue_finished)

func _process(_delta: float) -> void:
	if player_in_range and not dialogue_active and Input.is_action_just_pressed("chat"):
		dialogue_active = true
		single.emit_signal("Freeze")
		dialogue.start()

func _on_interaction_body_entered(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = true

func _on_interaction_body_exited(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = false


func _on_dialogue_dialogue_finished() -> void:
	dialogue_active = false
