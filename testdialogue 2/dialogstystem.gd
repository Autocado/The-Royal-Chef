extends Control

@export_file("*.json") var jsonsrc := "res://testdialogue 2/test_dialogue.json"
var scene_script : Dictionary
var current_block : Dictionary
var next_block : Dictionary

@export_category("scene reference")
@export var char_text : Label
@export var char_name : Label
@export var char_sprite : TextureRect

@export var BaseLayer : CanvasLayer
@export var ChoiceLayer : CanvasLayer

func _ready() -> void:
	get_json(jsonsrc)
	load_block(current_block)

func get_json(src: String):
	var jsontext = FileAccess.get_file_as_string(src)
	scene_script = JSON.parse_string(jsontext)
	current_block = scene_script["start"]

func load_block(block : Dictionary):
	if block.has("text"):	char_text.text = block["text"]
	if block.has("name"):	char_name.text = block["name"]
	
	if block.has("next"):
		var key = block["next"]
		next_block = scene_script[key]
	pass

	if block.has("choices"):
		ChoiceLayer.show()
		ChoiceLayer.set_choices(block["choices"])
	pass

func next():
	current_block = next_block
	load_block(current_block)
	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") :
		next()


func _on_choices_next_id(id: String) -> void:
	next_block = scene_script[id]
	next()
	ChoiceLayer.hide()
	pass # Replace with function body.
