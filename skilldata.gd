extends Resource
class_name skill

enum SkillType{
	Heal,
	Attack,
	defense,
	aoe
}
@export var type : SkillType
@export var max_hp : int
@export var min_damage : int
@export var max_damage : int
@export var defense : int
