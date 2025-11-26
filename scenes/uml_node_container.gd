extends Container
class_name UMLNodeContainer

signal name_changed(old_name: String, new_name: String)

@export var uml_node: UMLNode = UMLNode.new()

@onready var name_label: RichTextLabel = %Name
@onready var edit_popup: EditPopup = %EditPopup

var is_held: bool = false

func set_uml_node(p_uml_node: UMLNode) -> void:
	uml_node = p_uml_node
	name_label.text = "[b]%s[/b]" % uml_node.name

func _ready() -> void:
	name_label.text = "[b]%s[/b]" % uml_node.name
	name_label.gui_input.connect(_on_name_label_input)
	edit_popup.edit_finished.connect(_on_edit_finished)

func _on_name_label_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
		edit_popup.show_at_mouse_position(uml_node.name)

func _on_edit_finished(new_name: String) -> void:
	# uml_node.name = new_name
	# name_label.text = "[b]%s[/b]" % new_name
	name_changed.emit(uml_node.name, new_name)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and get_global_rect().has_point(event.position):
			is_held = true
			get_viewport().set_input_as_handled()
		else:
			is_held = false
	elif event is InputEventMouseMotion:
		if is_held:
			position += event.relative
