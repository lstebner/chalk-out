extends Control

const SIGNALS = {
    "INFO_UPDATED": "info_updated",
}

signal info_updated

var project = null

onready var name_input = $MarginContainer/GridContainer/Name
onready var notes_input = $MarginContainer/GridContainer/Notes
onready var save_button = $MarginContainer/GridContainer/Save
onready var current_status_input = $MarginContainer/GridContainer/CurrentStatus

func _ready():
    name_input.connect("text_changed", self, "_on_text_entered")
    notes_input.connect("text_changed", self, "_on_notes_changed")
    save_button.connect("pressed", self, "_on_save_button_pressed")
    current_status_input.connect("item_selected", self, "_on_current_status_item_selected")
    
    for state_key in Constants.PROJECT_STATES.keys():
        current_status_input.add_item(state_key)
    
func _draw():
    if !project:
        $Overlay.show() 
        return
        
    $Overlay.hide()
    name_input.text = project.name
    current_status_input.select(project.current_status)
    notes_input.text = project.notes
    
func _on_text_entered(new_string):
    project.name = new_string
    info_updated()

func _on_notes_changed():
    project.notes = notes_input.text
    info_updated()

func _on_save_button_pressed():
    AppData.store()
    
func set_project(value):
    project = value
    update()
    
func info_updated():
    emit_signal(SIGNALS.INFO_UPDATED)

func _on_current_status_item_selected(item_id):
    project.set_current_status(item_id)
