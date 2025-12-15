extends CharacterBody2D
@onready var animated_sprite_2d = $CharacterBody2D/idle
@export var speed = 80

func get_input():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
func _physics_process(_delta):
	var axisX = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var axisY = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	if axisX > 0:
		$idle.play("testwalk_d")
		$idle.flip_h = false
	elif axisX < 0:
		$idle.play("testwalk_d")
		$idle.flip_h = true
	elif axisY > 0:
		$idle.play("testwalk_w")
	elif axisY < 0:
		$idle.play("testwalk")
	else:
		$idle.play("white")
	get_input()
	move_and_slide()
	
