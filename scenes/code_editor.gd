extends CodeEdit
class_name UMLCodeEdit

signal diagram_parsed(uml_diagram: UMLDiagram)

const default_color: Color = Color(0, 0, 0, 0)

@export var string_color: Color = Color()
@export var comment_color: Color = Color()
@export var error_color: Color = Color()

@onready var update_timer: Timer = %UpdateTimer

var error_line: int = -1

func parse_code() -> void:
	var uml_diagram: UMLDiagram = UMLParser.parse_code(self.text)
	diagram_parsed.emit(uml_diagram)

	if uml_diagram and error_line != -1:
		dismiss_error()

func change_node_name(node: UMLNode, new_name: String):
	self.text = UMLParser.change_node_name(self.text, node, new_name)
	parse_code()

func change_node_position(node: UMLNode, new_position: Vector2):
	self.text = UMLParser.change_node_position(self.text, node, new_position)
	parse_code()

func show_error(message: String, line_number: int) -> void:
	error_line = line_number

	# TODO: Replace with proper error display in the UI
	print("Error on line %d: %s" % [line_number + 1, message])
	self.set_line_background_color(line_number, error_color)

func dismiss_error() -> void:
	self.set_line_background_color(error_line, default_color)
	error_line = -1

func _ready() -> void:
	assert(self.syntax_highlighter is CodeHighlighter)

	self.text_changed.connect(_on_text_changed)
	update_timer.timeout.connect(parse_code)

	self.add_comment_delimiter(UMLParser.COMMENT_PREFIX, "")

	var highlighter: CodeHighlighter = self.syntax_highlighter as CodeHighlighter
	highlighter.add_color_region("\"", "\"", string_color, false)
	highlighter.add_color_region(UMLParser.COMMENT_PREFIX, "", comment_color, true)

func _on_text_changed() -> void:
	update_timer.start()
