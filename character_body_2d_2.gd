extends CharacterBody2D

@onready var dialogue = $dialogue
@onready var interaction_area = $NpcInteractionArea
var player_body: CharacterBody2D

func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)
	dialogue.dialogue_started.connect(_on_dialogue_started)
	dialogue.dialogue_finished.connect(_on_dialogue_dialogue_finished)

func _on_interaction_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		player_body = body
		if !dialogue.d_active:
			dialogue.start()

func _on_interaction_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		if player_body:
			player_body.set_can_move(true)
		player_body = null

func _on_dialogue_started() -> void:
	if player_body:
		player_body.set_can_move(false)

func _on_dialogue_dialogue_finished() -> void:
	if player_body:
		player_body.set_can_move(true)
