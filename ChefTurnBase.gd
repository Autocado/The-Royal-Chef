extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Chef
@onready var turnity_socket: TurnitySocket = $TurnitySocket

var input_enabled := false
var action_in_progress := false

func _ready() -> void:
	sprite.play("Stand")
	turnity_socket.actor = self
	TurnityManager.activated_turn.connect(_on_turn_activated)
	TurnityManager.ended_turn.connect(_on_turn_ended)


func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled or action_in_progress:
		return
	if event.is_action_pressed("ui_accept"):
		action_in_progress = true
		get_viewport().set_input_as_handled()
		await _perform_attack()


func _on_turn_activated(socket: TurnitySocket) -> void:
	input_enabled = socket.actor == self
	if not input_enabled:
		action_in_progress = false


func _on_turn_ended(socket: TurnitySocket) -> void:
	if socket.actor == self:
		input_enabled = false
		action_in_progress = false


func _perform_attack() -> void:
	sprite.play("Skill")
	await get_tree().create_timer(0.4).timeout
	sprite.play("Stand")
	action_in_progress = false
	TurnityManager.next_turn()
