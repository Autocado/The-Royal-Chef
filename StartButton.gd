extends Control
@onready var animated_sprite := $Container/Start/Hover_Idle
@onready var animated_sprite2 := $Container/Start/Pressed

func _ready():
	# Ensure the sprite starts in the normal state
	animated_sprite.play("Idle")
	animated_sprite2.hide()
	animated_sprite.show()

func _input(event):
	# Check if the mouse is over the button's area
	if event.is_action_pressed("Click") and get_global_rect().has_point(get_global_mouse_position()):
		_on_button_pressed()
	elif event.is_action_released("Click") and get_global_rect().has_point(get_global_mouse_position()):
		_on_button_released()

func _on_button_pressed():
	animated_sprite.hide()
	animated_sprite2.show()
	animated_sprite2.play("Pressed")
	# Emit a custom signal if needed for other nodes to listen to
	# emit_signal("button_pressed")

func _on_button_released():
	if get_global_rect().has_point(get_global_mouse_position()):
		animated_sprite.show()
		animated_sprite.play("Hover")
	else:
		animated_sprite.show()
		animated_sprite.play("Idle")

func _on_mouse_entered():
	if not Input.is_action_pressed("Click"):
		animated_sprite.play("Hover")

func _on_mouse_exited():
	animated_sprite.play("Idle")
