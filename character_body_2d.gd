extends CharacterBody2D
var max_speed = 80
var last_direction := Vector2(1,0)

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * max_speed
	move_and_slide()
	
	
	if direction.length() > 0:
		last_direction = direction
		play_walk_animation(direction)
		print(direction)
	else:
		play_idle_animation(last_direction)
		print(direction)
		
func play_walk_animation(direction):
	if direction.x < 0:
		$idle.play("testwalk_a")
	elif direction.x > 0:
		$idle.play("testwalk_d")
	elif direction.y < 0:
		$idle.play("testwalk_w")
	elif  direction.y > 0:
		$idle.play("testwalk")
	
	
func play_idle_animation(direction):
	if direction.x < 0:
		$idle.play("idle_a")
	elif direction.x > 0:
		$idle.play("idle_d")
	elif direction.y < 0:
		$idle.play("idle_w")
	elif  direction.y > 0:
		$idle.play("idle_c")
