extends Node

enum {
	VISIBILITY_UNKNOWN,
	VISIBILITY_PUBLIC,
	VISIBILITY_PRIVATE,
	VISIBILITY_PACKAGE,
	VISIBILITY_PROTECTED
}

var class_regex: RegEx = RegEx.create_from_string("class\\s+([a-zA-Z_][a-zA-Z0-9_]*):")

func parse_code(code: String) -> UMLDiagram:
	var diagram: UMLDiagram = UMLDiagram.new()
	
	var lines: PackedStringArray = code.split("\n", false)
	var current_node: UMLNode = null
	var line_number: int = 0

	for line in lines:
		line_number += 1
		line = line.strip_edges()
		
		if "//" in line:
			line = line.substr(0, line.find("//")).strip_edges()
		
		if line.is_empty():
			continue
		
		var class_regex_match: RegExMatch = class_regex.search(line)
		if class_regex_match:
			var node_name: String = class_regex_match.get_string(1)
			current_node = UMLClass.new(node_name)
			diagram.nodes.append(current_node)
			continue

	return diagram
