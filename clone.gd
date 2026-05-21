extends Node2D

func spawn_clones():
	for i in 10:
		var e = $SlimeRoaming.instantiate()
		add_child(e)
		e.global_position = Vector2(randf() * 800, randf() * 600)
