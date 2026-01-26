extends TextureButton

@onready var Sprite = $Hover_Idle
@onready var Sprite2 = $Pressed
signal option
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sprite.show()
	Sprite.play("Idle")
	Sprite2.hide()
	preload("res://test.tscn")

func _on_button_up() -> void:
	Sprite.hide()
	Sprite2.show()
	Sprite2.play("Pressed")
	await get_tree().create_timer(0.7).timeout
	

func _on_mouse_entered() -> void:
	Sprite.play("Open")
	await get_tree().create_timer(0.7).timeout
	Sprite.play("Hover")
	$Flip.play()



func _on_mouse_exited() -> void:
	Sprite.play_backwards("Open")
	await get_tree().create_timer(0.7).timeout
	Sprite.play("Idle")


func _on_pressed() -> void:
	option.emit()
	hide()


func _on_back_back() -> void:
	show()
