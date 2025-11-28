extends Panel
class_name CodeEditor

signal diagram_parsed(uml_diagram: UMLDiagram)

const default_color: Color = Color(0, 0, 0, 0)

@export var string_color: Color = Color()
@export var comment_color: Color = Color()
@export var error_color: Color = Color()

@onready var code_edit: CodeEdit = %CodeEdit
@onready var update_timer: Timer = %UpdateTimer
@onready var error_container: MarginContainer = %ErrorContainer
@onready var error_label: RichTextLabel = %ErrorLabel

var error_line: int = -1

func parse_code() -> void:
	var uml_diagram: UMLDiagram = UMLParser.parse_code(code_edit.text)
	diagram_parsed.emit(uml_diagram)

	if uml_diagram and error_line != -1:
		dismiss_error()

func change_node_name(node: UMLNode, new_name: String):
	code_edit.text = UMLParser.change_node_name(code_edit.text, node, new_name)
	parse_code()

func change_node_position(node: UMLNode, new_position: Vector2):
	code_edit.text = UMLParser.change_node_position(code_edit.text, node, new_position)
	parse_code()

func show_error(message: String, line_number: int) -> void:
	if error_line != -1:
		code_edit.set_line_background_color(error_line, default_color)
	
	code_edit.set_line_background_color(line_number, error_color)
	error_label.text = "Error on line %d: %s" % [line_number + 1, message]
	error_container.show()
	error_line = line_number

func dismiss_error() -> void:
	if error_line < code_edit.get_line_count():
		code_edit.set_line_background_color(error_line, default_color)
	
	error_container.hide()
	error_line = -1

func _ready() -> void:
	assert(code_edit.syntax_highlighter is CodeHighlighter)

	code_edit.text_changed.connect(_on_text_changed)
	update_timer.timeout.connect(parse_code)

	code_edit.add_comment_delimiter(UMLParser.COMMENT_PREFIX, "")

	var highlighter: CodeHighlighter = code_edit.syntax_highlighter as CodeHighlighter
	highlighter.add_color_region("\"", "\"", string_color, false)
	highlighter.add_color_region(UMLParser.COMMENT_PREFIX, "", comment_color, true)

func _on_text_changed() -> void:
	update_timer.start()
