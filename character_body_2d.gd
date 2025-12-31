extends CharacterBody2D
var walk_speed = 80
var run_speed = 100
var last_direction := Vector2(1,0)
var current_speed: int = walk_speed

func _ready() -> void:
	if not single.Freeze.is_connected(_on_freeze_requested):
		single.Freeze.connect(_on_freeze_requested)
	if not single.unFreeze.is_connected(_on_unfreeze_requested):
		single.unFreeze.connect(_on_unfreeze_requested)

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * current_speed
	move_and_slide()
	
	if Input.is_action_pressed("run"):
		current_speed = run_speed
		velocity = direction * current_speed
		$idle.speed_scale = 2
	else:
		current_speed = walk_speed
		velocity = direction * current_speed
		$idle.speed_scale = 1
	
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

func _on_freeze_requested() -> void:
	velocity = Vector2.ZERO
	set_physics_process(false)
	set_process_input(false)
	$idle.stop()

func _on_unfreeze_requested() -> void:
	set_physics_process(true)
	set_process_input(true)
	
