extends Control
class_name Main

@onready var code_edit: UMLCodeEdit = %CodeEdit
@onready var visual_edit: VisualEdit = %VisualEdit

func _ready() -> void:
	UMLParser.error_occurred.connect(code_edit.show_error)
	code_edit.diagram_parsed.connect(visual_edit.render_diagram)
	visual_edit.node_name_changed.connect(code_edit.change_node_name)
	visual_edit.node_position_changed.connect(code_edit.change_node_position)
