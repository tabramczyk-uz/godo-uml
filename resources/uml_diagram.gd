extends Resource
class_name UMLDiagram

@export var nodes: Array[UMLNode] = []
@export var relationships: Array[UMLRelationship] = []

func _init(p_nodes: Array[UMLNode] = [], p_relationships: Array[UMLRelationship] = []) -> void:
    nodes = p_nodes
    relationships = p_relationships
