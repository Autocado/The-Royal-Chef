extends Node2D

@export var stats_resource : BattlerStats

@onready var health_bar : ProgressBar = $HealthBar
@onready var turn_indicator_animation : AnimationPlayer = $TurnIndicator/TurnIndicatorAnimation
@onready var animation_player : AnimatedSprite2D = $Enemy
@onready var hit_fx_animation : AnimatedSprite2D = $HitFX
@onready var select_target_button: TextureButton  = $TextureButton
@onready var focus_arrow = $TextureButton/AnimatedSprite2D

var current_hp : int

signal be_selected(this_target: Node2D)
signal dead(this_enemy: Node2D)
signal deal_damage(damage: int)

func _ready() -> void:
	select_target_button.hide()
	stop_turn()

	current_hp = stats_resource.max_hp

	select_target_button.pressed.connect(_on_select_button_pressed)

	_update_health_bar()

func _update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp
	
func start_turn() -> void:
	turn_indicator_animation.play("in-turn")
	_play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	deal_damage.emit(_get_attack_damage())

func stop_turn() -> void:
	turn_indicator_animation.play("RESET")
	animation_player.play("Idle")
	hit_fx_animation.play("RESET")

func show_select_button() -> void:
	select_target_button.show()
	focus_arrow.play("Focus")

func hide_select_button() -> void:
	select_target_button.hide()

func _on_select_button_pressed() -> void:
	be_selected.emit(self)

func _play_attack_anim() -> void:
	animation_player.play("hit")

func _get_attack_damage() -> int:
	return randi_range(stats_resource.min_damage, stats_resource.max_damage)

func play_hit_fx_anim() -> void:
	hit_fx_animation.play("Hit")

func be_damaged(amount: int) -> void:
	var final_damage = max(amount - stats_resource.defense, 0)
	current_hp -= final_damage
	_update_health_bar()
	if current_hp <= 0:
		current_hp = 0
		dead.emit(self)
		queue_free()
