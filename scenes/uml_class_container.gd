extends UMLNodeContainer
class_name UMLClassContainer

func set_uml_node(p_uml_node: UMLNode) -> void:
	super.set_uml_node(p_uml_node)
	assert(p_uml_node is UMLClass)

func _ready() -> void:
	if not uml_node is UMLClass:
		uml_node = UMLClass.new()
	super._ready()
