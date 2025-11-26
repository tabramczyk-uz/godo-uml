extends Panel
class_name VisualEdit

signal node_name_changed(old_name: String, new_name: String)

const UML_NODE_CONTAINER: PackedScene = preload("uid://cqijk423gtgaw")

@onready var anchor: Control = %Anchor

var is_dragging_view: bool = false

func render_diagram(diagram: UMLDiagram) -> void:
	for child in anchor.get_children():
		anchor.remove_child(child)
		child.queue_free()
	
	for node in diagram.nodes:
		add_uml_node(node)

func add_uml_node(node: UMLNode) -> void:
	var node_container: UMLNodeContainer = UML_NODE_CONTAINER.instantiate()
	anchor.add_child(node_container)
	node_container.set_uml_node(node)
	node_container.name_changed.connect(node_name_changed.emit)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_MIDDLE:
			if event.pressed and get_global_rect().has_point(event.position):
				is_dragging_view = true
				self.mouse_default_cursor_shape = CursorShape.CURSOR_DRAG
			elif not event.pressed:
				is_dragging_view = false
				self.mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
	elif event is InputEventMouseMotion:
		if is_dragging_view:
			anchor.position += event.relative
