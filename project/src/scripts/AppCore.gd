extends Node

const SIGNALS : Dictionary = {
	"PROJECT_CREATED": "project_created",
	"TASK_CREATED": "task_created",
}

signal project_created
signal task_created

func _ready():
	AppData.retrieve()

func save():
	AppData.store()
	
func create_project(name):
	AppData.add_project(name)
	emit_signal(SIGNALS.PROJECT_CREATED)
	
func get_projects():
	var projects = AppData.get_projects()
	projects.sort_custom(self, "sort_projects")
	return projects
	
func sort_projects(a, b):
	return a.name < b.name

func get_tasks_for_project(project_id):
	var project = AppData.get_project(project_id)
	if project:
		return project.get_tasks()
	
func create_task(subject, project_id):
	AppData.create_task(subject, project_id)
	emit_signal(SIGNALS.TASK_CREATED)
