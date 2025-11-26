extends CodeEdit
class_name UMLCodeEdit

signal diagram_parsed(uml_diagram: UMLDiagram)

@export var string_color: Color = Color()
@export var comment_color: Color = Color()

@onready var update_timer: Timer = %UpdateTimer

func parse_code() -> void:
	var uml_diagram: UMLDiagram = UMLParser.parse_code(self.text)
	diagram_parsed.emit(uml_diagram)

func change_class_name(old_name: String, new_name: String):
	# TODO: Replace with something more robust
	self.text = self.text.replace(old_name, new_name)
	parse_code()

func _ready() -> void:
	assert(self.syntax_highlighter is CodeHighlighter)

	self.text_changed.connect(_on_text_changed)
	update_timer.timeout.connect(parse_code)

	self.add_comment_delimiter("//", "")

	var highlighter: CodeHighlighter = self.syntax_highlighter as CodeHighlighter
	highlighter.add_color_region("\"", "\"", string_color, false)
	highlighter.add_color_region("//", "", comment_color, true)

func _on_text_changed() -> void:
	update_timer.start()
