extends Control

onready var create_menu = $VBoxContainer/MenuBar/MarginContainer/CreateMenuButton
onready var new_project_dialog = $NewProjectDialog
onready var projects_list = $VBoxContainer/Main/HBoxContainer/VBoxContainer/ProjectsList
onready var project_info = $VBoxContainer/Main/HBoxContainer/VBoxContainer/ProjectInfo
onready var tasks_list = $VBoxContainer/Main/HBoxContainer/TabContainer/Incomplete/TasksList
onready var completed_tasks = $VBoxContainer/Main/HBoxContainer/TabContainer/Completed/CompletedTasks
onready var task_details = $VBoxContainer/Main/HBoxContainer/TaskDetails
onready var import_file_dialog = $ImportFileDialog
onready var export_file_dialog = $ExportFileDialog

func _ready():
	AppCore.connect("project_created", self, "_on_project_created")
	create_menu.connect("item_selected", self, "_on_create_menu_item_selected")
	projects_list.connect("project_selected", self, "_on_project_selected")
	tasks_list.connect("task_selected", self, "_on_task_selected")
	task_details.connect("task_updated", self, "_on_task_details_updated")
	project_info.connect("info_updated", self, "_on_project_info_updated")
	import_file_dialog.connect("file_selected", self, "_on_import_dialog_file_selected")
	export_file_dialog.connect("file_selected", self, "_on_export_dialog_file_selected")
	completed_tasks.connect("task_selected", self, "_on_task_selected")
	
func _on_create_menu_item_selected(item_name):
	match item_name:
		"New Project":
			new_project_dialog.show()
		
		"Export Data":
			export_file_dialog.show()
		
		"Import Data":
			import_file_dialog.show()

func _on_project_selected(project_id):
	var project = AppData.get_project(project_id)
	tasks_list.set_project_id(project_id)
	completed_tasks.set_project(project)
	project_info.set_project(project)

func _on_project_created():
	new_project_dialog.hide()

func _on_task_selected(task):
	task_details.set_task(task)

func _on_task_details_updated():
	AppCore.save()
	tasks_list.update()
	completed_tasks.update()
	
func _on_project_info_updated():
	AppCore.save()
	projects_list.update()

func _on_import_dialog_file_selected(filename):
	var filedata = FileHelper.read(filename)
	AppData.load_state(filedata)
	get_tree().reload_current_scene()

func _on_export_dialog_file_selected(filename):
	var save_data = AppData.get_save_data()
	FileHelper.write(filename, save_data)
