extends Resource
class_name UMLMethod

@export var name: String = "method"
@export var return_type: String = "void"
@export var visibility: int = UMLParser.VISIBILITY_UNKNOWN
@export var arguments: Array[UMLMethodArgument] = []

func _init( \
	p_name: String = "method", \
	p_return_type: String = "void", \
	p_visibility: int = UMLParser.VISIBILITY_UNKNOWN, \
	p_arguments: Array[UMLMethodArgument] = []
) -> void:
	name = p_name
	return_type = p_return_type
	visibility = p_visibility
	arguments = p_arguments