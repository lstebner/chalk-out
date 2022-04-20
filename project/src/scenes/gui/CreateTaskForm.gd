extends HBoxContainer

const SIGNALS = {
	"CREATE_TASK": "create_task",
}

signal create_task

onready var input = $Input
onready var create_button = $Button

func _ready():
	input.connect("text_entered", self, "_on_text_entered")
	create_button.connect("pressed", self, "_on_create_pressed")

func _on_create_pressed():
	create()

func create():
	emit_signal(SIGNALS.CREATE_TASK, input.text.trim_suffix(" "))
	input.text = ""

func _on_text_entered(value):
	create()
	input.text = ""
