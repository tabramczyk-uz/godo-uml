extends Panel
class_name VisualEdit

signal node_name_changed(node: UMLNode, new_name: String)
signal node_position_changed(node: UMLNode, new_position: Vector2)

const UML_CLASS_CONTAINER: PackedScene = preload("uid://ckm2fdvved8ln")
const UML_NODE_CONTAINER: PackedScene = preload("uid://cqijk423gtgaw")

@export var drag_button: MouseButton = MouseButton.MOUSE_BUTTON_MIDDLE
@export var alt_drag_button: MouseButton = MouseButton.MOUSE_BUTTON_LEFT
@export var alt_drag_key: Key = Key.KEY_ALT
@export var scroll_sensitivity: float = 5.0

@onready var anchor: Control = %Anchor

var is_dragging_view: bool = false

func render_diagram(diagram: UMLDiagram) -> void:
	if not diagram:
		# TODO: Display that a new diagram wasn't rendered with grayed out UI
		return

	for child: Node in anchor.get_children():
		anchor.remove_child(child)
		child.queue_free()
	
	for node: UMLNode in diagram.nodes:
		add_uml_node(node)

func add_uml_node(node: UMLNode) -> void:
	var node_container: UMLNodeContainer = null

	match UMLParser.get_node_type(node):
		UMLParser.NodeType.CLASS:
			node_container = UML_CLASS_CONTAINER.instantiate()
		UMLParser.NodeType.NODE:
			node_container = UML_NODE_CONTAINER.instantiate()
		_:
			push_error("Unknown node type for UMLNode: %s" % node.name)
			return

	anchor.add_child(node_container)
	node_container.set_uml_node(node)
	node_container.name_changed.connect(node_name_changed.emit)
	node_container.position_changed.connect(node_position_changed.emit)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == drag_button \
		or (event.button_index == alt_drag_button and Input.is_key_pressed(alt_drag_key)):
			if event.pressed and get_global_rect().has_point(event.position):
				is_dragging_view = true
				self.mouse_default_cursor_shape = CursorShape.CURSOR_DRAG
			elif not event.pressed:
				is_dragging_view = false
				self.mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
		elif event.ctrl_pressed:
			if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
				anchor.scale *= 1.1
			elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
				anchor.scale *= 0.9
		# TODO: Make scrolling smoother on touchpads
		elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			anchor.position += scroll_sensitivity * Vector2.UP
		elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			anchor.position += scroll_sensitivity * Vector2.DOWN
		elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_LEFT:
			anchor.position += scroll_sensitivity * Vector2.LEFT
		elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_RIGHT:
			anchor.position += scroll_sensitivity * Vector2.RIGHT
	elif event is InputEventMouseMotion:
		if is_dragging_view:
			anchor.position += event.relative
