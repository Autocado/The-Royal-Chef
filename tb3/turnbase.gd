extends Node

@onready var turn_action_buttons: HBoxContainer = $Actioncontainer
@onready var skip_turn_button: Button = $Actioncontainer/Skip
@onready var unique_turn_button: Button = $Actioncontainer/Unique
@onready var defend_turn_button: Button = $Actioncontainer/defend
@onready var attack_button: Button = $Actioncontainer/Attack
@onready var run_button: Button = $Actioncontainer/Run
@onready var battle_end_panel: Panel = $BattleEndPanel
@onready var battle_end_text: RichTextLabel = $BattleEndPanel/BattleEndText

var all_battlers = []
var player_battlers = []
var enemy_battlers = []

var current_turn: Node2D
var current_turn_index: int

enum ActionMode { NONE, ATTACK, HEAL, UNIQUE }
var action_mode: ActionMode = ActionMode.NONE

func _ready() -> void:
	turn_action_buttons.hide()
	battle_end_panel.hide()

	player_battlers = get_tree().get_nodes_in_group("PlayerBattler")
	enemy_battlers = get_tree().get_nodes_in_group("EnemyBattler")

	all_battlers.append_array(player_battlers)
	all_battlers.append_array(enemy_battlers)

	all_battlers.sort_custom(_sort_turn_order_ascending)

	skip_turn_button.pressed.connect(_next_turn)
	attack_button.pressed.connect(_show_target_buttons)
	defend_turn_button.pressed.connect(_on_defend_pressed)
	unique_turn_button.pressed.connect(_on_unique_pressed)
	run_button.pressed.connect(_on_run_pressed)

	for p in player_battlers:
		p.turn_ended.connect(_next_turn)
		p.dead.connect(_on_player_dead)
		if p.has_signal("be_selected"):
			p.be_selected.connect(_heal_selected_ally)

	for e in enemy_battlers:
		e.be_selected.connect(_attack_selected_enemy)
		e.dead.connect(_on_enemy_dead)
		e.deal_damage.connect(_attack_random_player_battler)

	current_turn = all_battlers[current_turn_index]
	_update_turn()

func _sort_turn_order_ascending(battler_1, battler_2) -> bool:
	if battler_1.stats_resource.turn_speed < battler_2.stats_resource.turn_speed:
		return true
	return false

func _update_turn() -> void:
	action_mode = ActionMode.NONE
	if current_turn.stats_resource.type == BattlerStats.BattlerType.PLAYER:
		turn_action_buttons.show()
		if current_turn.has_method("_allow_attack"):
			attack_button.disabled = not current_turn._allow_attack()
		else:
			attack_button.disabled = false
	else: # Enemy
		turn_action_buttons.hide()

	current_turn.start_turn()

func _next_turn() -> void:
	if turn_action_buttons.visible:
		turn_action_buttons.hide()
	action_mode = ActionMode.NONE
	current_turn.stop_turn()

	if _check_for_battle_end() == false:
		current_turn_index = (current_turn_index + 1) % all_battlers.size()
		current_turn = all_battlers[current_turn_index]
		_update_turn()

func _show_target_buttons() -> void:
	turn_action_buttons.hide()
	action_mode = ActionMode.ATTACK
	for e in enemy_battlers:
		e.show_select_button()

func _show_ally_target() -> void:
	turn_action_buttons.hide()
	for p in  player_battlers:
		if p.has_method("show_select_button"):
			p.show_select_button()

func _hide_target_buttons() -> void:
	for e in enemy_battlers:
		e.hide_select_button()
	for p in player_battlers:
		if p.has_method("hide_select_button"):
			p.hide_select_button()

func _attack_selected_enemy(selected_enemy: Node2D) -> void:
	if action_mode != ActionMode.ATTACK:
		return
	_hide_target_buttons()
	action_mode = ActionMode.NONE
	current_turn.start_attacking(selected_enemy)

func _heal_selected_ally(selected_ally: Node2D) -> void:
	if action_mode == ActionMode.UNIQUE:
		_hide_target_buttons()
		action_mode = ActionMode.NONE
		if current_turn.has_method("start_unique_skill"):
			if current_turn.has_method("_get_heal_value"):
				current_turn.start_unique_skill(enemy_battlers, player_battlers, selected_ally)
		else:
			_next_turn()
		return
	if action_mode != ActionMode.HEAL:
		return
	_hide_target_buttons()
	action_mode = ActionMode.NONE
	if current_turn.has_method("start_healing"):
		current_turn.start_healing(selected_ally)
	else:
		_next_turn()

func _attack_random_player_battler(damage: int) -> void:
	var rand = randi_range(0, player_battlers.size() - 1)
	player_battlers[rand].play_hit_fx_anim()
	await get_tree().create_timer(0.5).timeout
	player_battlers[rand].be_damaged(damage)
	await get_tree().create_timer(0.1).timeout
	_next_turn()

func _on_defend_pressed() -> void:
	if current_turn.stats_resource.type == BattlerStats.BattlerType.PLAYER:
		current_turn.set_defending(true)
	_next_turn()

func _on_unique_pressed() -> void:
	if current_turn.stats_resource.type != BattlerStats.BattlerType.PLAYER:
		return
	turn_action_buttons.hide()
	if current_turn.has_method("unique_requires_target") and current_turn.unique_requires_target() == false:
		action_mode = ActionMode.NONE
		if current_turn.has_method("start_unique_skill"):
			current_turn.start_unique_skill(enemy_battlers, player_battlers)
		else:
			_next_turn()
		return
	action_mode = ActionMode.UNIQUE
	if current_turn.unique_requires_target() == true:
		if current_turn.has_method("_get_heal_value") :
			_show_ally_target()
		else :
			_show_target_buttons()

func _on_run_pressed() -> void:
	if current_turn.stats_resource.type != BattlerStats.BattlerType.PLAYER:
		return
	_end_battle("Player escaped!")
	get_tree().change_scene_to_file("res://forest.tscn")

func _on_enemy_dead(dead_enemy: Node2D) -> void:
	enemy_battlers.erase(dead_enemy)
	all_battlers.erase(dead_enemy)

func _on_player_dead(dead_battler: Node2D) -> void:
	player_battlers.erase(dead_battler)
	all_battlers.erase(dead_battler)

func _check_for_battle_end() -> bool:
	if enemy_battlers.is_empty():
		_show_battle_end_panel("Player won!")
		get_tree().change_scene_to_file("res://forest.tscn")
		return true
	elif player_battlers.is_empty():
		_show_battle_end_panel("Player lost!")
		get_tree().change_scene_to_file("res://forest.tscn")
		return true
	return false

func _end_battle(message: String) -> void:
	_show_battle_end_panel(message)
	if turn_action_buttons.visible:
		turn_action_buttons.hide()
	for e in enemy_battlers:
		if e.has_method("hide_select_button"):
			e.hide_select_button()
	for p in player_battlers:
		if p.has_method("hide_select_button"):
			p.hide_select_button()

func _show_battle_end_panel(message: String) -> void:
	battle_end_text.clear()
	battle_end_text.append_text("[center]%s" % [message])
	battle_end_panel.show()
	if turn_action_buttons.visible:
		turn_action_buttons.hide()
