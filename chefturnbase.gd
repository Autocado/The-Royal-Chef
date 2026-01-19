extends CharacterBody2D

# Nodes
@export var Health:Node
@export var attack:Node
@onready var entity_sprite = $Chef
@onready var health_bar = $HealthBar

# Target
var CurrentTargets:Array


# Stats
var Str:int
var Dex:int
var Int:int



func _ready():
	entity_sprite.play("Stand")
	attack.AttackSig.connect(AttackAnim)

func _process(delta):
	health_bar.value = Health.CurrentHP/Health.MaxHP

func LoadEntity(TargetRes):
	if TargetRes != PlayerStats:
		entity_sprite.flip_h = true
	Str = TargetRes.Str
	Dex = TargetRes.Dex
	Int = TargetRes.Int
	Health.MaxHP = TargetRes.MaxHP
	Health.CurrentHP = TargetRes.MaxHP
	
	attack.LoadSkills(TargetRes.Skills)
	Health.Death.connect(Death)

func ReceiveDamage(amount,type):
	Health.TakeDamage(amount,type)
	entity_sprite.play("hurt")



func Death():
	queue_free()


func _on_entity_sprite_animation_finished():
	print_debug(Health.CurrentHP)
	if Health.CurrentHP > 0:
		print_debug("SHould Play")
		entity_sprite.play("Stand")

func AttackAnim():
	entity_sprite.play("hit")

func MobAttack():
	attack.MobAttack()


func _on_chef_animation_finished() -> void:
	pass # Replace with function body.
