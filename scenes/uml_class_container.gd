extends UMLNodeContainer
class_name UMLClassContainer

func set_uml_node(p_uml_node: UMLNode) -> void:
	super.set_uml_node(p_uml_node)
	assert(p_uml_node is UMLClass)

func _ready() -> void:
	super._ready()
	assert(uml_node is UMLClass)
