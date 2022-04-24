extends Control

const SIGNALS = {
    "TASK_SELECTED": "task_selected",
}

signal task_selected(task)

var tasks = []
var project_id : int = 0
var task_nodes : Array = []

onready var tasks_container = $MarginContainer/VBoxContainer/Tasks
onready var tasks_list = $MarginContainer/VBoxContainer/Tasks
onready var create_task_form = $MarginContainer/VBoxContainer/CreateTaskForm

func _ready():
    create_task_form.connect("create_task", self, "_on_create_task")
    tasks_list.connect("item_selected", self, "_on_task_selected")
    
func _draw():
    var project_tasks = AppCore.get_tasks_for_project(project_id)
    tasks_list.clear()
    tasks = []
    
    if !project_tasks:
        return

    var selected_items = tasks_list.get_selected_items()
    
    for task in project_tasks:
        if !task.is_in_progress():
            tasks.append(task)
            tasks_container.add_item(task.subject)
        
    for item in selected_items:
        tasks_list.select(item, selected_items.size() == 1)
    
func set_project_id(value):
    project_id = value
    update()

func _on_create_task(subject):
    AppCore.create_task(subject, project_id)
    update()

func _on_task_selected(item_id):
    emit_signal(SIGNALS.TASK_SELECTED, tasks[item_id])
