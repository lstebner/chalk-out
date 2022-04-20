extends MenuButton

const SIGNALS = {
    "ITEM_SELECTED": "item_selected",
}

signal item_selected(item_name)

var item_names = [
    "New Project",
    "Import Data",
    "Export Data",
]

func _ready():
    get_popup().connect("id_pressed", self, "_on_menu_item_selected")
    
    for item in item_names:
        get_popup().add_item(item)

func _on_menu_item_selected(id):
    emit_signal(SIGNALS.ITEM_SELECTED, item_names[id])
