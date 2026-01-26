extends CharacterBody2D

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var animation_player = $Sprite

@export var MAX_HEALTH: float = 7

var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()
		_play_animation()

func _ready() -> void:
	animation_player.play("Idle")

func _update_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100

func _play_animation():
	animation_player.play("hurt")
	await get_tree().create_timer(0.7).timeout
	animation_player.play("Idle")

func focus():
	_focus.show()

func unfocus():
	_focus.hide()

func take_damage(value):
	health -= value
