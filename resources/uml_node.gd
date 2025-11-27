extends Resource
class_name UMLNode

@export var name: String = "Node"
@export var position: Vector2 = Vector2.ZERO

func _init(p_name: String = "Node", p_position: Vector2 = Vector2.ZERO) -> void:
	name = p_name
	position = p_position
