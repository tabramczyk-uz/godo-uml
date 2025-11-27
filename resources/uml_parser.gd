extends Node

signal error_occurred(message: String, line_number: int)

enum {
	VISIBILITY_UNKNOWN,
	VISIBILITY_PUBLIC,
	VISIBILITY_PRIVATE,
	VISIBILITY_PACKAGE,
	VISIBILITY_PROTECTED
}

enum NodeType {
	UNKNOWN,
	NODE,
	CLASS
}

enum NodeProperty {
	UNKNOWN,
	POSITION
}

const COMMENT_PREFIX: String = "//"

const NODE_REGEX_PATTERN: String = r"([a-zA-Z_][a-zA-Z0-9_]*)\s+([a-zA-Z_][a-zA-Z0-9_]*)"
const NODE_TYPE_NAMES: Dictionary[NodeType, String] = {
	NodeType.NODE: "node",
	NodeType.CLASS: "class"
}

const NODE_PROPERTY_REGEX_PATTERN: String = r"\t([a-zA-Z_][a-zA-Z0-9_]*):\s*(.+)"
const NODE_PROPERTY_NAMES: Dictionary[NodeProperty, String] = {
	NodeProperty.POSITION: "position"
}

const POSITION_REGEX_PATTERN: String = r"\[\s*([\-+]?\d*\.?\d+)\s*,\s*([\-+]?\d*\.?\d+)\s*\]"
const NEW_POSITION_LINE: String = "\t%s: [%s, %s]"

var node_regex: RegEx = RegEx.create_from_string(NODE_REGEX_PATTERN)
var property_regex: RegEx = RegEx.create_from_string(NODE_PROPERTY_REGEX_PATTERN)
var position_regex: RegEx = RegEx.create_from_string(POSITION_REGEX_PATTERN)

func parse_code(code: String) -> UMLDiagram:
	var diagram: UMLDiagram = UMLDiagram.new()
	
	var lines: PackedStringArray = code.split("\n", false)
	var line_number: int = -1
	var current_node: UMLNode = null
	var current_node_set_properties: Array[NodeProperty] = []
	var taken_node_names: Array[String] = []

	for line in lines:
		line_number += 1
		line = strip_end_edges_and_comments(line)
		
		if line.strip_edges(true, true).is_empty():
			continue
		
		if current_node:
			var indent_level: int = get_line_indentation(line)
			if indent_level == 0:
				current_node = null
				current_node_set_properties.clear()
			elif indent_level == 1:
				var property_match: RegExMatch = property_regex.search(line)
				if property_match:
					var property_name: String = property_match.get_string(1)
					var property_value: String = property_match.get_string(2)

					var property: NodeProperty = get_property_type_from_name(property_name)
					if property == NodeProperty.UNKNOWN:
						error_occurred.emit("Unknown property: %s" % property_name, line_number)
						return null
					elif property in current_node_set_properties:
						error_occurred.emit("Duplicate property: %s" % property_name, line_number)
						return null

					current_node_set_properties.append(property)

					match property:
						NodeProperty.POSITION:
							var position_match: RegExMatch = position_regex.search(property_value)
							if position_match:
								var x: float = position_match.get_string(1).to_float()
								var y: float = position_match.get_string(2).to_float()
								current_node.position = Vector2(x, y)
								continue
							else:
								error_occurred.emit("Invalid position format", line_number)
								return null

				error_occurred.emit("Invalid property syntax", line_number)
				return null
			else:
				error_occurred.emit("Unexpected indentation", line_number)
				return null
		
		var node_regex_match: RegExMatch = node_regex.search(line)
		if node_regex_match:
			var node_type_name: String = node_regex_match.get_string(1)
			var node_name: String = node_regex_match.get_string(2)

			if node_name in taken_node_names:
				error_occurred.emit("Duplicate node: %s" % node_name, line_number)
				return null

			var node_type: NodeType = get_node_type_from_name(node_type_name)
			match node_type:
				NodeType.NODE:
					current_node = UMLNode.new(node_name)
				NodeType.CLASS:
					current_node = UMLClass.new(node_name)
				_:
					error_occurred.emit("Unknown node type: %s" % node_type_name, line_number)
					return null

			diagram.nodes.append(current_node)
			taken_node_names.append(node_name)
			continue
		
		error_occurred.emit("Syntax error", line_number)
		return null

	return diagram

func change_node_name(code: String, node: UMLNode, new_name: String) -> String:
	var lines: PackedStringArray = code.split("\n", false)
	for line_number in range(lines.size()):
		var line: String = lines[line_number]
		var split_line: PackedStringArray = line.split(COMMENT_PREFIX)
		split_line[0].replace(node.name, new_name)
		lines[line_number] = COMMENT_PREFIX.join(split_line)

	return "\n".join(lines)

func change_node_position(code: String, node: UMLNode, new_position: Vector2) -> String:
	var property_name: String = NODE_PROPERTY_NAMES[NodeProperty.POSITION]
	var x_position: String = to_string_without_trailing_zeroes(new_position.x)
	var y_position: String = to_string_without_trailing_zeroes(new_position.y)

	var declaration_line_number: int = find_node_declaration(code, node)
	if declaration_line_number == -1:
		push_error("Node declaration not found for node: %s" % node.name)
		return code
	
	var lines: PackedStringArray = code.split("\n")
	for i in range(declaration_line_number + 1, lines.size()):
		var line: String = lines[i]
		var stripped_line: String = strip_end_edges_and_comments(line)
		if stripped_line.strip_edges(true, true).is_empty():
			continue

		if get_line_indentation(stripped_line) != 1:
			break
		
		var position_regex_match: RegExMatch = position_regex.search(stripped_line)
		if position_regex_match:
			var position_line: String = NEW_POSITION_LINE % [property_name, x_position, y_position]
			lines[i] = position_line
			return "\n".join(lines)
	
	var new_position_line: String = NEW_POSITION_LINE % [property_name, x_position, y_position]
	lines.insert(declaration_line_number + 1, new_position_line)
	return "\n".join(lines)

func find_node_declaration(code: String, node: UMLNode) -> int:
	var node_type: NodeType = get_node_type(node)
	var node_type_name: String = NODE_TYPE_NAMES[node_type]
	var regex: RegEx = RegEx.create_from_string("%s\\s+%s" % [node_type_name, node.name])

	var lines: PackedStringArray = code.split("\n")
	for line_number in range(lines.size()):
		var line: String = lines[line_number]
		var stripped_line: String = strip_end_edges_and_comments(line)
		if stripped_line.strip_edges(true, true).is_empty():
			continue

		var line_result: RegExMatch = regex.search(stripped_line)
		if line_result:
			return line_number

	return -1

func get_line_indentation(line: String) -> int:
	var indent: int = 0
	for character in line:
		if character == "\t":
			indent += 1
		else:
			break
	
	return indent

func get_node_type(node: UMLNode) -> NodeType:
	if node is UMLClass:
		return NodeType.CLASS
	else:
		return NodeType.NODE

func get_node_type_from_name(type_name: String) -> NodeType:
	for key: NodeType in NODE_TYPE_NAMES.keys():
		if NODE_TYPE_NAMES[key] == type_name:
			return key
	
	return NodeType.UNKNOWN

func get_property_type_from_name(property_name: String) -> NodeProperty:
	for key: NodeProperty in NODE_PROPERTY_NAMES.keys():
		if NODE_PROPERTY_NAMES[key] == property_name:
			return key
	
	return NodeProperty.UNKNOWN

func strip_end_edges_and_comments(line: String) -> String:
	if COMMENT_PREFIX in line:
		line = line.substr(0, line.find(COMMENT_PREFIX))
	
	line = line.strip_edges(false, true)
	return line

func to_string_without_trailing_zeroes(value: float) -> String:
	var str_value: String = str(value)
	if str_value.find(".") != -1:
		str_value = str_value.rstrip("0").rstrip(".")
	
	return str_value
