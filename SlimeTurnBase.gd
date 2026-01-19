extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Slime
@onready var turnity_socket: TurnitySocket = $TurnitySocket

var acting := false

func _ready() -> void:
	sprite.play("idle")
	turnity_socket.actor = self
	TurnityManager.activated_turn.connect(_on_turn_activated)
	TurnityManager.ended_turn.connect(_on_turn_ended)


func _on_turn_activated(socket: TurnitySocket) -> void:
	if socket.actor != self or acting:
		return

	acting = true
	await get_tree().create_timer(0.5).timeout
	sprite.play("attack")
	await get_tree().create_timer(0.4).timeout
	sprite.play("idle")
	acting = false
	TurnityManager.next_turn()


func _on_turn_ended(socket: TurnitySocket) -> void:
	if socket.actor == self:
		acting = false
