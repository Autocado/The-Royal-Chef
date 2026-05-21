extends CharacterBody2D

@export var speed: float = 50.0
var player: CharacterBody2D = null
@onready var anim = $Walk


func _ready():
	# Find the player in the scene tree
	player = get_tree().get_first_node_in_group("player")
	anim.play("Idle")
func _physics_process(_delta):
	if player:
		# 1. Calculate direction to player
		var direction = (player.global_position - global_position).normalized()
		
		# 2. Set velocity
		velocity = direction * speed
		
		# 3. Move the character
		move_and_slide()
		
func _on_battle_area_area_entered(area: Area2D) -> void:
	var actionable = $BattleArea.get_overlapping_areas()
	if actionable.size() > 0:
		get_tree().change_scene_to_file("res://tb3/turnbase.tscn")
		
