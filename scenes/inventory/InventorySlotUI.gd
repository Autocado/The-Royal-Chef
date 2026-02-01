extends PanelContainer
class_name InventorySlotUI

@onready var icon: TextureRect = $MarginContainer/Icon
@onready var count_label: Label = $Count


func set_slot(slot: InventorySlot) -> void:
	if slot == null or slot.is_empty():
		icon.texture = null
		count_label.text = ""
		return

	icon.texture = slot.item.icon
	if slot.quantity > 1:
		count_label.text = str(slot.quantity)
	else:
		count_label.text = ""
