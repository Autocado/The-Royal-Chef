extends TextureButton

@onready var Sprite = $Hover_Idle
@onready var Sprite2 = $Pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sprite.show()
	Sprite2.hide()
	preload("res://test.tscn")

func _on_button_up() -> void:
	Sprite.hide()
	Sprite2.show()
	Sprite2.play("Pressed")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://test.tscn")


func _on_mouse_entered() -> void:
	Sprite.play("Hover")


func _on_mouse_exited() -> void:
	Sprite.play("Idle")
