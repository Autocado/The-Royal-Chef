extends TextureRect

var speed = 0.25
var amplitude = 20.0
var original_y

func _ready():
	original_y = position.y

func _process(delta):
	# Sin wave creates a smooth back and forth
	position.y = original_y + sin(Time.get_ticks_msec() * 0.001 * speed) * amplitude


func _on_setting_option() -> void:
	pass # Replace with function body.
