extends Control

@onready var audio := $AudioStreamPlayer2D

func _ready():
	audio.stream.loop = true
	audio.play()
