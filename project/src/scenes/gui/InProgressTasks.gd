extends Control

signal task_selected(task)

var project = null
var tasks = []

onready var item_list = $MarginContainer/ItemList

func _ready():
    item_list.connect("item_selected", self, "_on_item_selected")

func _draw():
    var selected_items = item_list.get_selected_items()
    
    item_list.clear()
    tasks = []
    
    if !project: return
    
    for task in project.tasks:
        if task.is_in_progress():
            tasks.append(task)
            item_list.add_item(task.subject)
        
    for item in selected_items:
        item_list.select(item, selected_items.size() == 1)

func set_project(value):
    project = value
    update()

func _on_item_selected(index):
    emit_signal("task_selected", tasks[index])
