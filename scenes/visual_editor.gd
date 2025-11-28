extends Panel
class_name VisualEditor

signal node_name_changed(node: UMLNode, new_name: String)
signal node_position_changed(node: UMLNode, new_position: Vector2)

const UML_CLASS_CONTAINER: PackedScene = preload("uid://ckm2fdvved8ln")
const UML_NODE_CONTAINER: PackedScene = preload("uid://cqijk423gtgaw")

@export var drag_button: MouseButton = MouseButton.MOUSE_BUTTON_MIDDLE
@export var alt_drag_button: MouseButton = MouseButton.MOUSE_BUTTON_LEFT
@export var alt_drag_key: Key = Key.KEY_ALT
@export var scroll_sensitivity: float = 5.0

@onready var anchor: Control = %Anchor
@onready var gray_out: ColorRect = %GrayOut

var diagram: UMLDiagram = null
var is_dragging_view: bool = false
var containers: Dictionary[UMLNode, UMLNodeContainer] = {}

func render_diagram(new_diagram: UMLDiagram) -> void:
	var is_diagram_rendered: bool = new_diagram != null
	gray_out.visible = not is_diagram_rendered
	toggle_nodes(is_diagram_rendered)

	if not is_diagram_rendered:
		return
	
	diagram = new_diagram

	for child: Node in anchor.get_children():
		anchor.remove_child(child)
		child.queue_free()
	
	for node: UMLNode in new_diagram.nodes:
		add_uml_node(node)
	
	queue_redraw()

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
	containers[node] = node_container

func toggle_nodes(enabled: bool) -> void:
	for child: Node in anchor.get_children():
		if child is UMLNodeContainer:
			child.toggle_input(enabled)

func _draw() -> void:
	if diagram == null:
		return

	for relationship: UMLRelationship in diagram.relationships:
		assert(relationship.from != null)
		assert(relationship.to != null)

		var from_container: UMLNodeContainer = containers[relationship.from]
		var to_container: UMLNodeContainer = containers[relationship.to]

		var from_position: Vector2 = from_container.get_connection_point_position() - self.global_position
		var to_position: Vector2 = to_container.get_connection_point_position() - self.global_position

		draw_line(from_position, to_position, Color.WHITE, 2.0, true)

func _input(event: InputEvent) -> void:
	if diagram == null:
		return

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
			anchor.position += event.relative / anchor.scale
		queue_redraw()
