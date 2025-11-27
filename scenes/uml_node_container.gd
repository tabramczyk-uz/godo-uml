extends Container
class_name UMLNodeContainer

signal name_changed(node: UMLNode, new_name: String)
signal position_changed(node: UMLNode, new_position: Vector2)

@export var uml_node: UMLNode = UMLNode.new()

@onready var name_label: RichTextLabel = %Name
@onready var edit_popup: EditPopup = %EditPopup

var is_held: bool = false

func set_uml_node(p_uml_node: UMLNode) -> void:
	uml_node = p_uml_node
	name_label.text = uml_node.name
	self.position = uml_node.position

func _ready() -> void:
	name_label.text = uml_node.name
	name_label.gui_input.connect(_on_name_label_input)
	edit_popup.edit_finished.connect(_on_edit_finished)

func _on_name_label_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
		edit_popup.show_at_mouse_position(uml_node.name)

func _on_edit_finished(new_name: String) -> void:
	name_changed.emit(uml_node, new_name)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and get_global_rect().has_point(event.position):
			is_held = true
			get_viewport().set_input_as_handled()
		else:
			is_held = false
			if self.position != uml_node.position:
				position_changed.emit(uml_node, position)
	elif event is InputEventMouseMotion:
		if is_held:
			self.position += event.relative
