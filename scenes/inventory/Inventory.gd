extends Node
class_name Inventory

signal changed

@export var size: int = 16
@export var starter_items: Array[InventoryItem] = []
@export var starter_quantities: Array[int] = []

const DEFAULT_STARTER_ITEMS := [
	{"item": preload("res://resources/inventory/items/apple.tres"), "count": 3},
	{"item": preload("res://resources/inventory/items/bread.tres"), "count": 2},
	{"item": preload("res://resources/inventory/items/coin.tres"), "count": 12},
]

var slots: Array[InventorySlot] = []


func _ready() -> void:
	_initialize_slots()
	_apply_starter_items()
	changed.emit()


func _initialize_slots() -> void:
	slots.clear()
	for i in size:
		slots.append(InventorySlot.new())


func _apply_starter_items() -> void:
	if starter_items.is_empty():
		for entry in DEFAULT_STARTER_ITEMS:
			add_item(entry.item, entry.count)
		return

	for index in starter_items.size():
		var item := starter_items[index]
		var count := 1
		if index < starter_quantities.size():
			count = starter_quantities[index]
		add_item(item, count)


func add_item(item: InventoryItem, amount: int = 1) -> int:
	if item == null or amount <= 0:
		return amount

	var remaining := amount
	for slot in slots:
		if slot.can_stack(item):
			remaining = slot.add_amount(remaining)
			if remaining == 0:
				changed.emit()
				return 0

	for slot in slots:
		if slot.is_empty():
			slot.item = item
			remaining = slot.add_amount(remaining)
			if remaining == 0:
				changed.emit()
				return 0

	changed.emit()
	return remaining


func remove_item(item: InventoryItem, amount: int = 1) -> int:
	if item == null or amount <= 0:
		return amount

	var remaining := amount
	for slot in slots:
		if slot.item == item:
			remaining = slot.remove_amount(remaining)
			if remaining == 0:
				changed.emit()
				return 0

	changed.emit()
	return remaining


func get_slot(index: int) -> InventorySlot:
	if index < 0 or index >= slots.size():
		return null
	return slots[index]
