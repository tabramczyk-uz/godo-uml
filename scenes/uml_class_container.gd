extends Container
class_name UMLClassContainer

@export var uml_class: UMLClass
# @export var attributes: Array = []
# @export var methods: Array = []

@onready var name_label: RichTextLabel = %Name
@onready var edit_popup: EditPopup = %EditPopup

var is_held: bool = false

func set_uml_class(p_uml_class: UMLClass) -> void:
	uml_class = p_uml_class
	name_label.text = "[b]%s[/b]" % uml_class.name

func _ready() -> void:
	name_label.text = "[b]%s[/b]" % uml_class.name
	name_label.gui_input.connect(_on_name_label_input)
	edit_popup.edit_finished.connect(_on_edit_finished)
	Input.set_default_cursor_shape(Input.CURSOR_HSIZE)

func _on_name_label_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
		edit_popup.show_at_mouse_position(uml_class.name)

func _on_edit_finished(new_name: String) -> void:
	uml_class.name = new_name
	name_label.text = "[b]%s[/b]" % new_name

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and get_global_rect().has_point(event.position):
			is_held = true
		else:
			is_held = false
	elif event is InputEventMouseMotion:
		if is_held:
			position += event.relative
