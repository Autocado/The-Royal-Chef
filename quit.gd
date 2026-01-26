extends TextureButton

@onready var Sprite = $Hover_Idle
@onready var Sprite2 = $Pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sprite.show()
	Sprite2.hide()
	Sprite.play("Idle")

func _on_button_up() -> void:
	Sprite.hide()
	Sprite2.show()
	Sprite2.play("Pressed")
	await get_tree().create_timer(0.7).timeout


func _on_mouse_entered() -> void:
	Sprite.play("Ignite")
	await get_tree().create_timer(0.7).timeout
	Sprite.play("Hover")
	$"GET OUT".play()


func _on_mouse_exited() -> void:
	Sprite.play("Gone")
	await get_tree().create_timer(0.7).timeout
	Sprite.play("Idle")


func _on_pressed() -> void:
	get_tree().quit()


func _on_setting_option() -> void:
	hide()


func _on_back_back() -> void:
	show()
