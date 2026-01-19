extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Chef
@onready var turnity_socket: TurnitySocket = $TurnitySocket

var input_enabled := false
var action_in_progress := false

func _ready() -> void:
	sprite.play("Stand")
	turnity_socket.actor = self


func start_turn() -> void:
	input_enabled = true
	action_in_progress = false


func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled or action_in_progress:
		return
	if event.is_action_pressed("ui_accept"):
		action_in_progress = true
		get_viewport().set_input_as_handled()
		await _perform_attack()

func end_turn() -> void:
	input_enabled = false
	action_in_progress = false


func _perform_attack() -> void:
	sprite.play("Skill")
	await get_tree().create_timer(0.4).timeout
	sprite.play("Stand")
	action_in_progress = false
	TurnityManager.next_turn()
