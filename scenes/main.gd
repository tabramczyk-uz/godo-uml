extends Control
class_name Main

@onready var code_edit: UMLCodeEdit = %CodeEdit
@onready var visual_edit: VisualEdit = %VisualEdit

func _ready() -> void:
	code_edit.diagram_parsed.connect(visual_edit.render_diagram)
	visual_edit.node_name_changed.connect(code_edit.change_class_name)
