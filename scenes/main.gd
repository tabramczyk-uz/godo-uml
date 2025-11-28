extends Control
class_name Main

@onready var code_editor: CodeEditor = %CodeEditor
@onready var visual_editor: VisualEditor = %VisualEditor

func _ready() -> void:
	UMLParser.error_occurred.connect(code_editor.show_error)
	code_editor.diagram_parsed.connect(visual_editor.render_diagram)
	visual_editor.node_name_changed.connect(code_editor.change_node_name)
	visual_editor.node_position_changed.connect(code_editor.change_node_position)
