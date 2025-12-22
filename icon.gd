extends Node2D
@onready var animated_sprite_2d = $CharacterBody2D/idle
@onready var animated_npc = $CharacterBody2D2/Nidle
@onready var dialogue = $dialogue
@onready var player = $CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("white")
	animated_npc.play("npc")
	dialogue.dialogue_started.connect(_on_dialogue_dialogue_started)
	dialogue.dialogue_finished.connect(_on_dialogue_dialogue_finished)
	

func _on_dialogue_dialogue_started() -> void:
	player.can_move = false

func _on_dialogue_dialogue_finished() -> void:
	player.can_move = true


func _on_npc_interaction_area_body_entered(body: Node) -> void:
	if Input.is_action_just_pressed("chat"):
		dialogue.start()
