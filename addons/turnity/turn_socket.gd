class_name TurnitySocket extends Node

signal active_turn
signal ended_turn
signal changed_turn_duration(old_duration: int, new_duration: int)
signal reset_current_timer
signal blocked_n_turns(turns: int, total_turns: int)
signal blocked_turn_consumed(remaining_turns: int)
signal blocked_turns_removed
signal skipped
signal enabled_socket
signal disabled_socket

## The linked actor in the turn system
@export var actor: Node
## The turn duration for this socket, leave it to zero to make it infinite
@export var turn_duration := 0
## Automatically move on to next turn when this socket is skipped
@export var next_turn_when_skipped := true
## Automatically move on to next turn when this socket is blocked
@export var next_turn_when_blocked := true

var id: String
var active := false
var disabled := false:
	set(value):
		if value != disabled:
			if value:
				disabled_socket.emit()
			else:
				enabled_socket.emit()
				
		disabled = value
var blocked_turns := 0


func _enter_tree():
	add_to_group("turnity-socket")
	
	if id == null or id.is_empty():
		id = _generate_random_id()
	
	if not actor:
		actor = get_parent()
		if actor == null:
			push_error("Turnity: The TurnitySocket needs a valid actor linked, cannot stand alone")


func _ready():
	
	active_turn.connect(on_active_turn)
	ended_turn.connect(on_ended_turn)
	






func reset_blocked_turns():
	if blocked_turns > 0:
		blocked_turns = 0
		blocked_turns_removed.emit()


func block_a_number_of_turns(turns: int):
	blocked_turns += turns
	blocked_n_turns.emit(turns, blocked_turns)


func is_blocked() -> bool:
	return blocked_turns > 0


func skip():
	if active:
		skipped.emit()


func enable() -> void:
	disabled = false
	
	
func disable() -> void:
	disabled = true


func is_disabled() -> bool:
	return disabled
	
	
func _generate_random_id(length: int = 20, characters: String =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):
	var random_number_generator = RandomNumberGenerator.new()
	var result = ""
	
	if not characters.is_empty() and length > 0:
		for i in range(length):
			result += characters[random_number_generator.randi() % characters.length()]

	return result
	
### SIGNAL CALLBACKS ###
func on_active_turn():
	if is_disabled():
		skip()
	else:
		active = true
		
		if blocked_turns > 0:
			blocked_turns -= 1
			blocked_turn_consumed.emit(blocked_turns)
			return
		

func on_ended_turn():
	active = false
	ended_turn.emit()
