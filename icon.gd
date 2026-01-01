extends Node2D
@onready var animated_sprite_2d = $CharacterBody2D/idle
@onready var animated_npc = $CharacterBody2D2/Nidle
@onready var player = $CharacterBody2D
const COLLISION_CONTAINER_NAME := "GeneratedCollisions"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("white")
	animated_npc.play("npc")
	_add_tile_collisions($Water, 1.0, $bridge)
	_add_tile_collisions($"trees 1", 0.5)
	_add_tile_collisions($"trees 2", 0.5)
	_add_tile_collisions($building, 1.0, null, Vector2(0.8, 0.6))
	_add_tile_collisions($castle)
	

func _add_tile_collisions(tile_map: TileMapLayer, height_fraction: float = 1.0, skip_map: TileMapLayer = null, collision_scale: Vector2 = Vector2.ONE) -> void:
	var existing_container := tile_map.get_node_or_null(COLLISION_CONTAINER_NAME)
	if existing_container:
		existing_container.queue_free()

	var collision_container := Node2D.new()
	collision_container.name = COLLISION_CONTAINER_NAME
	tile_map.add_child(collision_container)

	var tile_size := Vector2(tile_map.tile_set.tile_size)
	var collision_size := Vector2(tile_size.x * collision_scale.x, tile_size.y * height_fraction * collision_scale.y)
	var skip_cells := {}
	if skip_map:
		for cell in skip_map.get_used_cells():
			skip_cells[cell] = true
	for cell in tile_map.get_used_cells():
		if skip_cells.has(cell):
			continue
		var collision_shape := CollisionShape2D.new()
		var rectangle := RectangleShape2D.new()
		rectangle.size = collision_size
		collision_shape.shape = rectangle

		var static_body := StaticBody2D.new()
		static_body.position = tile_map.map_to_local(cell) + Vector2(tile_size.x * 0.5, tile_size.y - collision_size.y * 0.5)
		static_body.add_child(collision_shape)
		collision_container.add_child(static_body)


func _on_dialogue_dialogue_finished() -> void:
	pass # Replace with function body.
