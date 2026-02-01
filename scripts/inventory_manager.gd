extends Node

signal inventory_changed

@export var starting_items: Dictionary = {
	"Tomato": 2,
	"Mushroom": 2,
	"Meat": 1,
	"Herb": 1
}

var items: Dictionary = {}

func _ready() -> void:
	items = starting_items.duplicate(true)
	inventory_changed.emit()

func add_item(item_name: String, amount: int = 1) -> void:
	if amount <= 0:
		return
	items[item_name] = int(items.get(item_name, 0)) + amount
	inventory_changed.emit()

func remove_item(item_name: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	var current := int(items.get(item_name, 0))
	if current < amount:
		return false
	var remaining := current - amount
	if remaining > 0:
		items[item_name] = remaining
	else:
		items.erase(item_name)
	inventory_changed.emit()
	return true

func has_items(requirements: Dictionary) -> bool:
	for key in requirements.keys():
		if int(items.get(key, 0)) < int(requirements[key]):
			return false
	return true

func consume_items(requirements: Dictionary) -> bool:
	if not has_items(requirements):
		return false
	for key in requirements.keys():
		remove_item(key, int(requirements[key]))
	return true

func get_sorted_items() -> Array:
	var list: Array = []
	for key in items.keys():
		list.append({
			"name": key,
			"count": int(items[key])
		})
	list.sort_custom(func(a, b): return String(a["name"]) < String(b["name"]))
	return list
