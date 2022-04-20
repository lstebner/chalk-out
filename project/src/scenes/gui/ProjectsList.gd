extends Control

signal project_selected(project_id)

onready var item_list = $VBoxContainer/ItemList

var selected_value = null
var projects : Array = []

func _ready():
	projects = AppCore.get_projects()
	
	AppCore.connect("project_created", self, "_on_project_created")
	item_list.connect("item_selected", self, "_on_project_selected")

func _draw():
	var selected_items = item_list.get_selected_items()
	item_list.clear()
	
	for project in projects:
		item_list.add_item(project.name)
	
	for item in selected_items:
		item_list.select(item, selected_items.size() == 1)

func _on_project_created():
	projects = AppCore.get_projects()
	update()

func _on_project_selected(item_id):
	emit_signal("project_selected", projects[item_id].id)
