extends Control

@export var inventory_manager_path: NodePath

@onready var inventory_manager: Node = get_node_or_null(inventory_manager_path)
@onready var inventory_panel: Panel = get_node_or_null("InventoryPanel")
@onready var inventory_list: ItemList = get_node_or_null("InventoryPanel/InventoryList")
@onready var cooking_panel: Panel = get_node_or_null("CookingPanel")
@onready var recipe_list: ItemList = get_node_or_null("CookingPanel/RecipeList")
@onready var recipe_details: RichTextLabel = get_node_or_null("CookingPanel/RecipeDetails")
@onready var cook_button: Button = get_node_or_null("CookingPanel/CookButton")
@onready var prompt_label: Label = get_node_or_null("PromptLabel")

var recipes := [
	{
		"name": "Hearty Stew",
		"ingredients": {"Meat": 1, "Mushroom": 1, "Herb": 1},
		"result": "Hearty Stew",
		"description": "A warm stew that restores energy after a long day."
	},
	{
		"name": "Tomato Medley",
		"ingredients": {"Tomato": 2, "Herb": 1},
		"result": "Tomato Medley",
		"description": "Fresh tomatoes tossed with herbs for a light dish."
	},
	{
		"name": "Mushroom Skillet",
		"ingredients": {"Mushroom": 2, "Tomato": 1},
		"result": "Mushroom Skillet",
		"description": "A quick sear with a savory finish."
	}
]

var _selected_recipe_index := -1
var _is_initialized := false

func _ready() -> void:
	if inventory_manager == null:
		push_warning("KitchenHUD is missing InventoryManager reference.")
		return
	if inventory_panel == null or inventory_list == null or cooking_panel == null \
			or recipe_list == null or recipe_details == null or cook_button == null or prompt_label == null:
		push_warning("KitchenHUD is missing required UI nodes.")
		return
	inventory_panel.visible = false
	cooking_panel.visible = false
	prompt_label.visible = false
	inventory_manager.inventory_changed.connect(_refresh_inventory)
	recipe_list.item_selected.connect(_on_recipe_list_item_selected)
	cook_button.pressed.connect(_on_cook_button_pressed)
	_setup_recipe_list()
	_refresh_inventory()
	_is_initialized = true

func _unhandled_input(event: InputEvent) -> void:
	if not _is_initialized:
		return
	if event.is_action_pressed("inventory_toggle"):
		inventory_panel.visible = not inventory_panel.visible

func _setup_recipe_list() -> void:
	recipe_list.clear()
	for recipe in recipes:
		recipe_list.add_item(recipe["name"])

func _refresh_inventory() -> void:
	inventory_list.clear()
	for entry in inventory_manager.get_sorted_items():
		inventory_list.add_item("%s x%d" % [entry["name"], entry["count"]])
	_update_recipe_state()

func _update_recipe_state() -> void:
	if not _is_initialized:
		return
	if _selected_recipe_index < 0:
		cook_button.disabled = true
		return
	var recipe = recipes[_selected_recipe_index]
	cook_button.disabled = not inventory_manager.has_items(recipe["ingredients"])

func show_cooking() -> void:
	if not _is_initialized:
		return
	inventory_panel.visible = true
	cooking_panel.visible = true
	_update_recipe_state()

func hide_cooking() -> void:
	if not _is_initialized:
		return
	cooking_panel.visible = false

func show_prompt(text: String) -> void:
	if not _is_initialized:
		return
	prompt_label.text = text
	prompt_label.visible = true

func hide_prompt() -> void:
	if not _is_initialized:
		return
	prompt_label.visible = false

func _on_recipe_list_item_selected(index: int) -> void:
	if not _is_initialized:
		return
	_selected_recipe_index = index
	var recipe = recipes[index]
	var requirements: Array[String] = []
	for key in recipe["ingredients"].keys():
		requirements.append("%s x%d" % [key, recipe["ingredients"][key]])
	recipe_details.text = "[b]%s[/b]\n%s\n\nRequires:\n%s" % [
		recipe["name"],
		recipe["description"],
		"\n".join(requirements)
	]
	_update_recipe_state()

func _on_cook_button_pressed() -> void:
	if not _is_initialized:
		return
	if _selected_recipe_index < 0:
		return
	var recipe = recipes[_selected_recipe_index]
	if inventory_manager.consume_items(recipe["ingredients"]):
		inventory_manager.add_item(recipe["result"], 1)
		recipe_details.text = "[b]%s[/b]\n%s\n\nCooked!" % [
			recipe["name"],
			recipe["description"]
		]
