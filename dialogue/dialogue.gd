extends Control

signal dialogue_finished

@export_file("*.json") var d_file := "res://dialogue/dialogue1.json"

var dialogue = []
var current_dialogue_id = 0
var d_active=false

@onready var dialogue_box: NinePatchRect = get_node_or_null("NinePatchRect")
@onready var name_label: RichTextLabel = dialogue_box != null ? dialogue_box.get_node_or_null("name") : null
@onready var text_label: RichTextLabel = dialogue_box != null ? dialogue_box.get_node_or_null("text") : null

func _ready():
	if dialogue_box != null:
		dialogue_box.visible = false
		
func start():
	if d_active:
		return
	if not _ensure_ui():
		return
	dialogue_box.visible = true
	d_active = true
	dialogue = load_dialogue()
	if dialogue.is_empty():
		d_active = false
		dialogue_box.visible = false
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
		dialogue_box.visible = false
		emit_signal("dialogue_finished")
		UnFreeze()
		return
	
	name_label.text = dialogue[current_dialogue_id]['name']
	text_label.text = dialogue[current_dialogue_id]['text']
func UnFreeze():
	single.emit_signal("unFreeze")

func _ensure_ui() -> bool:
	if dialogue_box == null:
		push_error("Dialogue UI is missing. Ensure a NinePatchRect exists as a direct child of the Dialogue node.")
		return false
	if name_label == null or text_label == null:
		push_error("Dialogue UI is missing required child labels (name or text).")
		return false
	return true
