extends CanvasLayer

signal dialogue_started
signal dialogue_finished

@export_file("*.json") var d_file

var dialogue = []
var current_dialogue_id = 0
var d_active=false

func _ready():
	$Overlay.visible = false
	$UI/NinePatchRect.visible = false
	
func start():
	if d_active:
		return
	$Overlay.visible = true
	$UI/NinePatchRect.visible = true
	emit_signal("dialogue_started")
	d_active = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()
	
func load_dialogue():
	var file = FileAccess.open("res://dialogue/dialogue1.json",FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
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
		$Overlay.visible = false
		$UI/NinePatchRect.visible = false
		emit_signal("dialogue_finished")
		return
	
	$UI/NinePatchRect/name.text = dialogue[current_dialogue_id]['name']
	$UI/NinePatchRect/text.text = dialogue[current_dialogue_id]['text']
	
