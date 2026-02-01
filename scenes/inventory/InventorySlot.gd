extends Resource
class_name InventorySlot

@export var item: InventoryItem
@export var quantity: int = 0


func is_empty() -> bool:
	return item == null or quantity <= 0


func can_stack(incoming: InventoryItem) -> bool:
	return incoming != null and item == incoming and quantity < item.max_stack


func add_amount(amount: int) -> int:
	if item == null:
		return amount

	var space_left := item.max_stack - quantity
	var to_add := min(space_left, amount)
	quantity += to_add
	return amount - to_add


func remove_amount(amount: int) -> int:
	var to_remove := min(quantity, amount)
	quantity -= to_remove
	if quantity <= 0:
		item = null
		quantity = 0
	return amount - to_remove
