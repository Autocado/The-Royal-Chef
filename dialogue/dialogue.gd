extends Control

signal dialogue_finished

@export_file("*.json") var d_file := "res://dialogue/dialogue1.json"

var dialogue = []
var current_dialogue_id = 0
var d_active=false

func _ready():
	$NinePatchRect.visible = false
	
func start():
	if d_active:
		return
	$NinePatchRect.visible = true
	d_active = true
	dialogue = load_dialogue()
	if dialogue.is_empty():
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialogue_finished")
		return
	current_dialogue_id = -1
	next_script()
	
func load_dialogue():
	var file_path = d_file
	if file_path.is_empty():
		push_error("Dialogue file path is empty.")
		return []
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open dialogue file: %s" % file_path)
		return []
	var content = JSON.parse_string(file.get_as_text())
	if content == null:
		push_error("Failed to parse dialogue JSON: %s" % file_path)
		return []
	return content

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
	
func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue) :
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialogue_finished")
		return
	
	$NinePatchRect/name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/text.text = dialogue[current_dialogue_id]['text']
	
