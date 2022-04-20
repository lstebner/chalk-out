extends HBoxContainer

onready var input = $Input
onready var submit_button = $Button

func _ready():
	input.connect("text_entered", self, "_on_text_entered")
	submit_button.connect("pressed", self, "_on_submit_pressed")

func show():
	.show()
	input.grab_focus()
	
func _on_submit_pressed():
	create()

func _on_text_entered(_text):
	create()

func create():
	AppCore.create_project(input.text.trim_suffix(" "))
	input.text = ""
