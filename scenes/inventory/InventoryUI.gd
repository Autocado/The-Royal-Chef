extends Control
class_name InventoryUI

@export var inventory_path: NodePath
@export var slot_scene: PackedScene
@export var columns: int = 4

@onready var grid: GridContainer = $Panel/MarginContainer/Grid

var _inventory: Inventory
var _slot_nodes: Array[InventorySlotUI] = []


func _ready() -> void:
	set_process_unhandled_input(true)
	visible = false
	grid.columns = columns
	_inventory = get_node_or_null(inventory_path) as Inventory
	if _inventory == null:
		push_warning("InventoryUI: Inventory node not found at %s" % inventory_path)
		return

	_inventory.changed.connect(_refresh)
	_build_slots()
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = not visible
		if visible:
			_refresh()


func _build_slots() -> void:
	for child in grid.get_children():
		child.queue_free()
	_slot_nodes.clear()

	for index in _inventory.slots.size():
		var slot_ui := slot_scene.instantiate() as InventorySlotUI
		grid.add_child(slot_ui)
		_slot_nodes.append(slot_ui)


func _refresh() -> void:
	if _inventory == null:
		return
	if _slot_nodes.size() != _inventory.slots.size():
		_build_slots()

	for index in _inventory.slots.size():
		var slot := _inventory.slots[index]
		_slot_nodes[index].set_slot(slot)
