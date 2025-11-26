extends Resource
class_name UMLDiagram

@export var nodes: Array[UMLNode] = []

func _init(p_nodes: Array[UMLNode] = []) -> void:
    nodes = p_nodes
