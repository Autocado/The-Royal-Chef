extends Node2D

@export var stats_resource : BattlerStats
@export var skill_resource : skill
@onready var health_bar : ProgressBar = $HealthBar
@onready var turn_indicator_animation : AnimationPlayer = $TurnIndicator/TurnIndicatorAnimation
@onready var animation_player: AnimatedSprite2D = $Holder
@onready var hit_fx_animation : AnimatedSprite2D = $HitFX
@onready var select_target_button : TextureButton = $TextureButton
@onready var focus_arrow : AnimatedSprite2D = $TextureButton/AnimatedSprite2D

var current_hp : int
var is_defending:= false

signal dead(this_battler: Node2D) 
signal turn_ended
signal be_selected(this_target: Node2D)

func _ready() -> void:
	stop_turn()
	current_hp = stats_resource.max_hp
	
	_update_health_bar()

func _update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp

func start_turn() -> void:
	turn_indicator_animation.play("in-turn")
	is_defending = false

func stop_turn() -> void:
	turn_indicator_animation.play("RESET")
	animation_player.play("stand")
	hit_fx_animation.play("RESET")

func start_attacking(enemy_target: Node2D) -> void:
	_play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	enemy_target.play_hit_fx_anim()
	await get_tree().create_timer(0.5).timeout
	enemy_target.be_damaged(_get_attack_damage())
	await get_tree().create_timer(0.1).timeout
	turn_ended.emit()

func start_unique_skill(enemy_targets: Array, _ally_targets: Array, _selected_ally: Node2D = null) -> void:
	_play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	var damage = _get_unique_damage()
	for enemy in enemy_targets:
		if enemy == null:
			continue
		if enemy.has_method("play_hit_fx_anim"):
			enemy.play_hit_fx_anim()
		if enemy.has_method("be_damaged"):
			enemy.be_damaged(damage)
	await get_tree().create_timer(0.1).timeout
	turn_ended.emit()

func _play_attack_anim() -> void:
	animation_player.play("attack")

func show_select_button() -> void:
	select_target_button.show()
	focus_arrow.play("Focus")

func hide_select_button() -> void:
	select_target_button.hide()

func _on_select_button_pressed() -> void:
	be_selected.emit(self)

func _get_attack_damage() -> int:
	return randi_range(stats_resource.min_damage, stats_resource.max_damage)

func _get_unique_damage() -> int:
	if skill_resource != null and skill_resource.type == skill.SkillType.Attack:
		return randi_range(skill_resource.min_damage, skill_resource.max_damage)
	return _get_attack_damage()

func play_hit_fx_anim() -> void:
	hit_fx_animation.play("hit")

func be_damaged(amount: int) -> void:
	if is_defending == true:
		var final_damage = max(amount - (stats_resource.defense*2), 0)
		current_hp -= final_damage
	else:
		var final_damage = max(amount - stats_resource.defense, 0)
		current_hp -= final_damage
	_update_health_bar()
	if current_hp <= 0:
		current_hp = 0
		dead.emit(self)
		queue_free()

func be_healed(amount: int = 0) -> void:
	if amount < stats_resource.max_hp:
		return
	current_hp = min(current_hp + amount, stats_resource.max_hp)
	_update_health_bar()

func _on_battlescene_defense() -> void:
	is_defending = true


func set_defending(active: bool) -> void:
	is_defending = active


func _on_player_battler_heal_skill() -> void:
	be_healed()

func unique_requires_target() -> bool:
	return false
