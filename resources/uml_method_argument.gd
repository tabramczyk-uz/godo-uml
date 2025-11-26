extends Resource
class_name UMLMethodArgument

@export var name: String = "argument"
@export var type: String = "Integer"

func _init(p_name: String = "argument", p_type: String = "Integer") -> void:
    name = p_name
    type = p_type
