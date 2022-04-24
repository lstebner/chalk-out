extends Node

const STORAGE_FILENAME = "user://appdata.save"

var data = {
    "last_id": 0,
    "projects": [],
}

class Project:
    signal status_changed
    
    var id = 0
    var name = ""
    var notes = ""
    var current_status = 0
    var tasks = []
    var is_archived = false
    
    func get_tasks():
        return tasks
        
    func add_task(task):
        tasks.append(task)
    
    func get_save_state():
        var tasks_data = []
        for task in tasks:
            tasks_data.append(task.get_save_state())
        
        return {
            "id": id,
            "name": name,
            "tasks": tasks_data,
            "is_archived": is_archived,
            "notes": notes,
            "current_status": current_status,
        }
    
    func load_state(state_value):
        id = state_value.id
        name = state_value.name
        is_archived = state_value.is_archived
        
        if state_value.has("notes"):
            notes = state_value.notes
        
        if state_value.has("current_status"):
            current_status = state_value.current_status
        
        for task_state in state_value.tasks:
            var new_task = Task.new()
            new_task.load_state(task_state)
            tasks.append(new_task)
    
    func create_task(subject):
        var new_task = Task.new()
        new_task.subject = subject
        
        return new_task
    
    func set_current_status(value):
        current_status = value
        emit_signal("status_changed")
    
class Task:
    signal state_changed
    
    var subject = ""
    var description = ""
    var current_state = Constants.TASK_STATES.OPEN
    var is_archived = false
    var notes = ""
    
    func get_save_state():
        return {
            "subject": subject,
            "description": description,
            "current_state": current_state,
            "is_archived": is_archived,
            "notes": notes,
        }
        
    func load_state(state_data):
        subject = state_data.subject
        description = state_data.description
        current_state = state_data.current_state
        is_archived = state_data.is_archived
        if state_data.has("notes"):
            notes = state_data.notes
        
    func change_state(new_state):
        current_state = new_state
        emit_signal("state_changed")
    
    func is_completed():
        return current_state == Constants.TASK_STATES.COMPLETED
    
    func is_in_progress():
        var in_progress_states = [
            Constants.TASK_STATES.IN_PROGRESS,
            Constants.TASK_STATES.PAUSED,
            Constants.TASK_STATES.BLOCKED,
        ]
        
        return in_progress_states.has(current_state)
    
    func is_open():
        return current_state == Constants.TASK_STATES.OPEN

func retrieve():
    var stored_data = FileHelper.read(STORAGE_FILENAME)
    
    if stored_data != null:
        load_state(stored_data)

func load_state(state):
    data = {
        "last_id": state.last_id,
        "projects": [],
    }
    
    for project_data in state.projects:
        var new_project = Project.new()	
        new_project.load_state(project_data)
        data.projects.append(new_project)
    
func store():
    FileHelper.write(STORAGE_FILENAME, get_save_data())

func get_save_data():
    var projects = []
    for project in data.projects:
        projects.append(project.get_save_state())
        
    return {
        "last_id": data.last_id,
        "projects": projects,
    }
    
func next_id():
    var next_id = data.last_id + 1
    data.last_id = next_id
    
    return next_id

func add_project(name):
    var project = Project.new()
    project.name = name
    project.id = next_id()
    
    data.projects.append(project)
    
    store()
    
func get_projects():
    return data.projects

func create_task(subject, project_id):
    for project in data.projects:
        if project.id == project_id:
            var new_task = project.create_task(subject)
            project.add_task(new_task)
            break
    
    store()

func get_project(project_id):
    for project in data.projects:
        if project.id == project_id:
            return project
