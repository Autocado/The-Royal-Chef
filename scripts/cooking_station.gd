extends Area2D

@export var hud_path: NodePath

@onready var hud: Control = get_node(hud_path)

var _player_inside := false
var _is_open := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		_player_inside = true
		hud.show_prompt("Press E to cook")

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		_player_inside = false
		hud.hide_prompt()
		if _is_open:
			_is_open = false
			hud.hide_cooking()

func _unhandled_input(event: InputEvent) -> void:
	if _player_inside and event.is_action_pressed("Interact"):
		_is_open = not _is_open
		if _is_open:
			hud.show_cooking()
		else:
			hud.hide_cooking()
