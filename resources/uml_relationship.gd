extends Resource
class_name UMLRelationship

@export var from: UMLNode = null
@export var to: UMLNode = null
# TODO: Add label, type, etc.

func _init(p_from: UMLNode = null, p_to: UMLNode = null) -> void:
	from = p_from
	to = p_to
