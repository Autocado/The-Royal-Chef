extends TextureButton

signal back
@onready var anim = $Arrow
func _ready() -> void:
	anim.flip_h = true
	anim.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	anim.play("Idle")


func _on_pressed() -> void:
	back.emit()


func _on_mouse_entered() -> void:
	anim.play("Back")


func _on_mouse_exited() -> void:
	anim.play("Idle")
