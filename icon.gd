extends Node2D
@onready var animated_sprite_2d = $CharacterBody2D/idle
@onready var animated_npc = $CharacterBody2D2/Nidle
@onready var dialogue = $CharacterBody2D2/dialogue
@onready var player = $CharacterBody2D
var player_z_index := 0
var npc_z_index := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("white")
	animated_npc.play("npc")
	player_z_index = animated_sprite_2d.z_index
	npc_z_index = animated_npc.z_index
	dialogue.dialogue_started.connect(_on_dialogue_dialogue_started)
	dialogue.dialogue_finished.connect(_on_dialogue_dialogue_finished)
	


func _on_dialogue_dialogue_finished() -> void:
	animated_sprite_2d.z_index = player_z_index
	animated_npc.z_index = npc_z_index

func _on_dialogue_dialogue_started() -> void:
	animated_sprite_2d.z_index = 100
	animated_npc.z_index = 100

func _on_npc_interaction_area_body_entered(body: Node) -> void:
	if Input.is_action_just_pressed("chat"):
		dialogue.start()
