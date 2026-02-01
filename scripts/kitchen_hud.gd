extends Control

@export var inventory_manager_path: NodePath

@onready var inventory_manager: Node = get_node(inventory_manager_path)
@onready var inventory_panel: Panel = %InventoryPanel
@onready var inventory_list: ItemList = %InventoryList
@onready var cooking_panel: Panel = %CookingPanel
@onready var recipe_list: ItemList = %RecipeList
@onready var recipe_details: RichTextLabel = %RecipeDetails
@onready var cook_button: Button = %CookButton
@onready var prompt_label: Label = %PromptLabel

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

func _ready() -> void:
	inventory_panel.visible = false
	cooking_panel.visible = false
	prompt_label.visible = false
	inventory_manager.inventory_changed.connect(_refresh_inventory)
	recipe_list.item_selected.connect(_on_recipe_list_item_selected)
	cook_button.pressed.connect(_on_cook_button_pressed)
	_setup_recipe_list()
	_refresh_inventory()

func _unhandled_input(event: InputEvent) -> void:
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
	if _selected_recipe_index < 0:
		cook_button.disabled = true
		return
	var recipe = recipes[_selected_recipe_index]
	cook_button.disabled = not inventory_manager.has_items(recipe["ingredients"])

func show_cooking() -> void:
	inventory_panel.visible = true
	cooking_panel.visible = true
	_update_recipe_state()

func hide_cooking() -> void:
	cooking_panel.visible = false

func show_prompt(text: String) -> void:
	prompt_label.text = text
	prompt_label.visible = true

func hide_prompt() -> void:
	prompt_label.visible = false

func _on_recipe_list_item_selected(index: int) -> void:
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
	if _selected_recipe_index < 0:
		return
	var recipe = recipes[_selected_recipe_index]
	if inventory_manager.consume_items(recipe["ingredients"]):
		inventory_manager.add_item(recipe["result"], 1)
		recipe_details.text = "[b]%s[/b]\n%s\n\nCooked!" % [
			recipe["name"],
			recipe["description"]
		]
