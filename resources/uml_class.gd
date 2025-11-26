extends UMLNode
class_name UMLClass

@export var attributes: Array[UMLAttribute] = []
@export var methods: Array[UMLMethod] = []

func _init(p_name: String = "Class", p_attributes: Array[UMLAttribute] = [], p_methods: Array[UMLMethod] = []) -> void:
    name = p_name
    attributes = p_attributes
    methods = p_methods
