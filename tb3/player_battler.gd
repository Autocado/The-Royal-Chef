extends Node2D

@export var stats_resource : BattlerStats
@export var skill_resource : skill
@onready var health_bar : ProgressBar = $HealthBar
@onready var turn_indicator_animation : AnimationPlayer = $TurnIndicator/TurnIndicatorAnimation
@onready var animation_player: AnimatedSprite2D = $Chef
@onready var hit_fx_animation : AnimatedSprite2D = $HitFX
@onready var select_target_button: TextureButton = $TextureButton
@onready var focus_arrow: AnimatedSprite2D = $TextureButton/AnimatedSprite2D

var current_hp : int
var is_defending:= false
var allow_attack := false

signal dead(this_battler: Node2D) 
signal turn_ended
signal heal_skill
signal be_selected(this_target: Node2D)

func _ready() -> void:
	stop_turn()
	select_target_button.hide()
	select_target_button.pressed.connect(_on_select_button_pressed)

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
	animation_player.play("Stand")
	hit_fx_animation.play("RESET")

func start_healing(target: Node2D) -> void:
	if target == null or not target.has_method("be_healed"):
		turn_ended.emit()
		return
	_play_skill_anim()
	await get_tree().create_timer(0.8).timeout
	target.be_healed(_get_heal_value())
	await get_tree().create_timer(0.1).timeout
	turn_ended.emit()

func _play_skill_anim() -> void:
	animation_player.play("Skill")

func _get_heal_value() -> int:
	if skill_resource == null:
		return 0
	return skill_resource.hp

func play_hit_fx_anim() -> void:
	hit_fx_animation.play("default")

func show_select_button() -> void:
	select_target_button.show()
	focus_arrow.play("Focus")

func hide_select_button() -> void:
	select_target_button.hide()

func _on_select_button_pressed() -> void:
	be_selected.emit(self)

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
	if amount <= 0:
		return
	current_hp = min(current_hp + amount, stats_resource.max_hp)
	_update_health_bar()

func _allow_attack() -> bool:
	return allow_attack
	

func _on_battlescene_defense() -> void:
	is_defending = true


func set_defending(active: bool) -> void:
	is_defending = active


func _on_battlescene_unique_skill() -> void:
	pass
