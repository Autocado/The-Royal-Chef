extends Node2D

const TURN_ORDER := {
	"ChefTurnBase": 0,
	"SlimeTurnBase": 1,
}

func _ready() -> void:
	TurnityManager.activated_turn.connect(_on_turn_activated)
	TurnityManager.ended_turn.connect(_on_turn_ended)

	TurnityManager.set_serial_mode()
	TurnityManager.set_sort_rule(_sort_turn_order)
	TurnityManager.start(self)


func _sort_turn_order(a: TurnitySocket, b: TurnitySocket) -> bool:
	var a_name := a.actor.name if a.actor else a.get_parent().name
	var b_name := b.actor.name if b.actor else b.get_parent().name
	return TURN_ORDER.get(a_name, 99) < TURN_ORDER.get(b_name, 99)


func _on_turn_activated(socket: TurnitySocket) -> void:
	var actor := socket.actor
	if actor and actor.has_method("start_turn"):
		actor.start_turn()


func _on_turn_ended(socket: TurnitySocket) -> void:
	var actor := socket.actor
	if actor and actor.has_method("end_turn"):
		actor.end_turn()
