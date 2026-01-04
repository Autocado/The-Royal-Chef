extends CharacterBody2D

@onready var dialogue = $dialogue
@onready var interaction_area = $NpcInteractionArea
@onready var player: CharacterBody2D = $"../CharacterBody2D"

@export var speaker_name := "Jeff"
@export var prompt_message := ""
@export var prompt_scene_path := ""

var player_in_range := false
var player_frozen := false
var awaiting_choice := false
var prompt_visible := false

func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)
	dialogue.dialogue_finished.connect(_on_dialogue_dialogue_finished)

func _process(_delta: float) -> void:
	if awaiting_choice:
		if Input.is_action_just_pressed("ui_yes") or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("chat"):
			_accept_choice()
		elif Input.is_action_just_pressed("ui_no"):
			_decline_choice()
		return
	if player_in_range and Input.is_action_just_pressed("chat"):
		if prompt_message != "" and prompt_scene_path != "":
			_show_prompt()
			return
		single.emit_signal("Freeze",Callable())
		freeze_player()
		dialogue.start()

func _on_interaction_body_entered(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = true

func _on_interaction_body_exited(body: Node) -> void:
	if body.name == "CharacterBody2D":
		player_in_range = false
		if prompt_visible:
			_hide_prompt()


func freeze_player():
	if player and not player_frozen:
		player.set_physics_process(false)
		player.set_process_input(false)
		player_frozen = true

func unfreeze_player():
	if player and player_frozen:
		player.set_physics_process(true)
		player.set_process_input(true)
		player_frozen = false

func _on_dialogue_dialogue_finished() -> void:
	unfreeze_player()
	single.emit_signal("unFreeze")

func _show_prompt() -> void:
	single.emit_signal("Freeze", Callable())
	freeze_player()
	awaiting_choice = true
	prompt_visible = true
	dialogue.show_custom_message(speaker_name, prompt_message)

func _accept_choice() -> void:
	if prompt_scene_path == "" or not ResourceLoader.exists(prompt_scene_path):
		push_error("Prompt scene path is invalid: %s" % prompt_scene_path)
		return
	_hide_prompt()
	get_tree().call_deferred("change_scene_to_file", prompt_scene_path)

func _decline_choice() -> void:
	_hide_prompt()

func _hide_prompt() -> void:
	dialogue.hide_custom_message()
	awaiting_choice = false
	prompt_visible = false
	unfreeze_player()
