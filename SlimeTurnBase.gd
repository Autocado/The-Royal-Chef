extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Slime
@onready var turnity_socket: TurnitySocket = $TurnitySocket

var acting := false

func _ready() -> void:
	sprite.play("idle")
	turnity_socket.actor = self


func start_turn() -> void:
	if acting:
		return

	acting = true
	await get_tree().create_timer(0.5).timeout
	sprite.play("attack")
	await get_tree().create_timer(0.4).timeout
	sprite.play("idle")
	acting = false
	TurnityManager.next_turn()


func end_turn() -> void:
	acting = false
