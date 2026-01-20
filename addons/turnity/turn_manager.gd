extends Node2D
@export var scene_to_clone: PackedScene  # Drag your scene/node here
@export var clone_count: int = 10
@export var spawn_area_size: Vector2 = Vector2(500, 500)

func _ready() -> void:
	# Initialize the random number generator
	randomize() 
	spawn_clones()

func spawn_clones():
	for i in range(4):
		var clone = scene_to_clone.instantiate()
		
			# 2. Generate random coordinates
		var random_x = randf_range(0, spawn_area_size.x)
		var random_y = randf_range(0, spawn_area_size.y)
		
		# 3. Set the position
		clone.position = Vector2(random_x, random_y)
		
		# 4. Add it to the scene tree
		add_child(clone)
