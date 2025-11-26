extends Resource
class_name UMLAttribute

@export var name: String = "attribute"
@export var type: String = "Integer"
@export var visibility: int = UMLParser.VISIBILITY_UNKNOWN

func _init(p_name: String = "attribute", p_type: String = "Integer", p_visibility: int = UMLParser.VISIBILITY_UNKNOWN) -> void:
    name = p_name
    type = p_type
    visibility = p_visibility
