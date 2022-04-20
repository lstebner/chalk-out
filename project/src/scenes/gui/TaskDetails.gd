extends Control

signal task_updated

var task = null

onready var subject_input = $GridContainer/Subject
onready var status_label = $GridContainer/Status
onready var description_input = $GridContainer/Description
onready var notes_input = $GridContainer/Notes
onready var save_button = $GridContainer/Save
onready var start_button = $GridContainer/Start
onready var in_progress_actions = $GridContainer/InProgressActions
onready var pause_button = $GridContainer/InProgressActions/Pause
onready var complete_button = $GridContainer/InProgressActions/Complete
onready var resume_button = $GridContainer/InProgressActions/Resume
onready var reopen_button = $GridContainer/Reopen

func _ready():
    save_button.connect("pressed", self, "_on_save_button_pressed")
    start_button.connect("pressed", self, "_on_start_button_pressed")
    pause_button.connect("pressed", self, "_on_pause_button_pressed")
    complete_button.connect("pressed", self, "_on_complete_button_pressed")
    resume_button.connect("pressed", self, "_on_resume_button_pressed")
    reopen_button.connect("pressed", self, "_on_reopen_button_pressed")
    subject_input.connect("text_changed", self, "_on_subject_text_changed")
    description_input.connect("text_changed", self, "_on_description_text_changed")
    notes_input.connect("text_changed", self, "_on_notes_text_changed")
    
func _draw():
    if !task: 
        $Overlay.show()
        return
    
    $Overlay.hide()
    
    if subject_input.text != task.subject:
        subject_input.text = task.subject
    status_label.text = "%s" % Constants.TASK_STATES.keys()[task.current_state]
    if description_input.text != task.description:
        description_input.text = task.description
    if notes_input.text != task.notes:
        notes_input.text = task.notes
    
    if task.current_state == Constants.TASK_STATES.OPEN:
        in_progress_actions.hide()
        start_button.show()
        reopen_button.hide()
    elif task.current_state == Constants.TASK_STATES.COMPLETED:
        in_progress_actions.hide()
        start_button.hide()
        reopen_button.show()
    else:
        reopen_button.hide()
        
        if task.current_state == Constants.TASK_STATES.PAUSED:
            resume_button.show()
            pause_button.hide()
        else:
            resume_button.hide()
            pause_button.show()
            
        in_progress_actions.show()
        start_button.hide()
    
func set_task(value):
    if task:
        task.disconnect("state_changed", self, "_on_task_state_changed")
        
    task = value
    task.connect("state_changed", self, "_on_task_state_changed")
    update()

func _on_save_button_pressed():
    task.notes = notes_input.text
    task.description = description_input.text
    emit_signal("save")

func _on_start_button_pressed():
    task.change_state(Constants.TASK_STATES.IN_PROGRESS)

func _on_pause_button_pressed():
    task.change_state(Constants.TASK_STATES.PAUSED)

func _on_complete_button_pressed():
    task.change_state(Constants.TASK_STATES.COMPLETED)

func _on_resume_button_pressed():
    task.change_state(Constants.TASK_STATES.IN_PROGRESS)
    
func _on_reopen_button_pressed():
    task.change_state(Constants.TASK_STATES.OPEN)

func _on_task_state_changed():
    task_updated()
    
func task_updated():
    update()
    emit_signal("task_updated")

func _on_subject_text_changed(new_text):
    task.subject = new_text.trim_suffix(" ")
    task_updated()

func _on_description_text_changed():
    task.description = description_input.text
    task_updated()

func _on_notes_text_changed():
    task.notes = notes_input.text
    task_updated()
