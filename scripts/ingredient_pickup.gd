extends Area2D

@export var item_name: String = ""
@export var amount: int = 1
@export var inventory_manager_path: NodePath
@export var hud_path: NodePath

@onready var inventory_manager: Node = get_node(inventory_manager_path)
@onready var hud: Control = get_node(hud_path)

var _player_inside := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		_player_inside = true
		hud.show_prompt("Press E to pick up %s" % item_name)

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		_player_inside = false
		hud.hide_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if _player_inside and event.is_action_pressed("Interact"):
		inventory_manager.add_item(item_name, amount)
		hud.hide_prompt()
		queue_free()
