extends GutTest

# ============ Parse Code Tests ============

func test_parse_empty_code() -> void:
	var result = UMLParser.parse_code("")
	assert_not_null(result, "Should parse empty code successfully")
	assert_eq(result.nodes.size(), 0, "Should have no nodes")
	assert_eq(result.relationships.size(), 0, "Should have no relationships")

func test_parse_single_node() -> void:
	var code = "node MyNode"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse single node")
	assert_eq(result.nodes.size(), 1, "Should have one node")
	assert_eq(result.nodes[0].name, "MyNode", "Node name should be MyNode")

func test_parse_single_class() -> void:
	var code = "class MyClass"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse single class")
	assert_eq(result.nodes.size(), 1, "Should have one node")
	assert_is(result.nodes[0], UMLClass, "Node should be UMLClass")
	assert_eq(result.nodes[0].name, "MyClass", "Class name should be MyClass")

func test_parse_multiple_nodes() -> void:
	var code = "node Node1\nnode Node2\nclass Class1"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse multiple nodes")
	assert_eq(result.nodes.size(), 3, "Should have three nodes")

func test_parse_node_with_position() -> void:
	var code = "node MyNode\n\tposition: [100.5, 200.75]"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse node with position")
	assert_eq(result.nodes[0].position, Vector2(100.5, 200.75), "Position should be set correctly")

func test_parse_node_with_negative_position() -> void:
	var code = "node MyNode\n\tposition: [-50, -100.5]"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse node with negative position")
	assert_eq(result.nodes[0].position, Vector2(-50, -100.5), "Position should have negative values")

func test_parse_node_with_integer_position() -> void:
	var code = "node MyNode\n\tposition: [100, 200]"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse node with integer position")
	assert_eq(result.nodes[0].position, Vector2(100, 200), "Position should handle integers")

func test_parse_node_with_comments() -> void:
	var code = "node MyNode // This is a comment\n\tposition: [100, 200] // Another comment"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse node with comments")
	assert_eq(result.nodes[0].name, "MyNode", "Node name should ignore comments")
	assert_eq(result.nodes[0].position, Vector2(100, 200), "Position should ignore comments")

func test_parse_two_nodes_relationship() -> void:
	var code = "node Node1\nnode Node2\nNode1 -- Node2"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse relationship")
	assert_eq(result.relationships.size(), 1, "Should have one relationship")
	assert_eq(result.relationships[0].from.name, "Node1", "Relationship from should be Node1")
	assert_eq(result.relationships[0].to.name, "Node2", "Relationship to should be Node2")

func test_parse_error_duplicate_node() -> void:
	var code = "node MyNode\nnode MyNode"
	var error_caught = false
	UMLParser.error_occurred.connect(func(_msg, _line): error_caught = true)
	var result = UMLParser.parse_code(code)
	assert_true(error_caught, "Should emit error for duplicate node")
	assert_null(result, "Should return null on error")

func test_parse_error_duplicate_property() -> void:
	var code = "node MyNode\n\tposition: [100, 200]\n\tposition: [300, 400]"
	var error_caught = false
	UMLParser.error_occurred.connect(func(_msg, _line): error_caught = true)
	var result = UMLParser.parse_code(code)
	assert_true(error_caught, "Should emit error for duplicate property")
	assert_null(result, "Should return null on error")

func test_parse_error_invalid_position_format() -> void:
	var code = "node MyNode\n\tposition: invalid"
	var error_caught = false
	UMLParser.error_occurred.connect(func(_msg, _line): error_caught = true)
	var result = UMLParser.parse_code(code)
	assert_true(error_caught, "Should emit error for invalid position format")
	assert_null(result, "Should return null on error")

func test_parse_error_unknown_node_type() -> void:
	var code = "unknown MyNode"
	var error_caught = false
	UMLParser.error_occurred.connect(func(_msg, _line): error_caught = true)
	var result = UMLParser.parse_code(code)
	assert_true(error_caught, "Should emit error for unknown node type")
	assert_null(result, "Should return null on error")

func test_parse_error_unknown_property() -> void:
	var code = "node MyNode\n\tunknown_prop: value"
	var error_caught = false
	UMLParser.error_occurred.connect(func(_msg, _line): error_caught = true)
	var result = UMLParser.parse_code(code)
	assert_true(error_caught, "Should emit error for unknown property")
	assert_null(result, "Should return null on error")

func test_parse_error_relationship_unknown_from_node() -> void:
	var code = "node Node2\nUnknown -- Node2"
	var error_caught = false
	UMLParser.error_occurred.connect(func(_msg, _line): error_caught = true)
	var result = UMLParser.parse_code(code)
	assert_true(error_caught, "Should emit error for unknown from node")
	assert_null(result, "Should return null on error")

func test_parse_error_relationship_unknown_to_node() -> void:
	var code = "node Node1\nNode1 -- Unknown"
	var error_caught = false
	UMLParser.error_occurred.connect(func(_msg, _line): error_caught = true)
	var result = UMLParser.parse_code(code)
	assert_true(error_caught, "Should emit error for unknown to node")
	assert_null(result, "Should return null on error")

# ============ Get Node Type Tests ============

func test_get_node_type_from_name_node() -> void:
	var result = UMLParser.get_node_type_from_name("node")
	assert_eq(result, UMLParser.NodeType.NODE, "Should return NodeType.NODE for 'node'")

func test_get_node_type_from_name_class() -> void:
	var result = UMLParser.get_node_type_from_name("class")
	assert_eq(result, UMLParser.NodeType.CLASS, "Should return NodeType.CLASS for 'class'")

func test_get_node_type_from_name_unknown() -> void:
	var result = UMLParser.get_node_type_from_name("unknown")
	assert_eq(result, UMLParser.NodeType.UNKNOWN, "Should return NodeType.UNKNOWN for unknown type")

# ============ Get Property Type Tests ============

func test_get_property_type_from_name_position() -> void:
	var result = UMLParser.get_property_type_from_name("position")
	assert_eq(result, UMLParser.NodeProperty.POSITION, "Should return NodeProperty.POSITION for 'position'")

func test_get_property_type_from_name_unknown() -> void:
	var result = UMLParser.get_property_type_from_name("unknown")
	assert_eq(result, UMLParser.NodeProperty.UNKNOWN, "Should return NodeProperty.UNKNOWN for unknown property")

# ============ Get Node Type Tests ============

func test_get_node_type_uml_node() -> void:
	var node = UMLNode.new("TestNode")
	var result = UMLParser.get_node_type(node)
	assert_eq(result, UMLParser.NodeType.NODE, "Should return NodeType.NODE for UMLNode")

func test_get_node_type_uml_class() -> void:
	var node = UMLClass.new("TestClass")
	var result = UMLParser.get_node_type(node)
	assert_eq(result, UMLParser.NodeType.CLASS, "Should return NodeType.CLASS for UMLClass")

# ============ Change Node Name Tests ============

func test_change_node_name() -> void:
	var code = "node OldName"
	var node = UMLNode.new("OldName")
	var result = UMLParser.change_node_name(code, node, "NewName")
	assert_true(result.contains("NewName"), "Result should contain new name")

func test_change_node_name_with_comment() -> void:
	var code = "node OldName // comment"
	var node = UMLNode.new("OldName")
	var result = UMLParser.change_node_name(code, node, "NewName")
	assert_true(result.contains("NewName"), "Result should contain new name")
	assert_true(result.contains("// comment"), "Result should preserve comment")

# ============ Change Node Position Tests ============

func test_change_node_position_existing() -> void:
	var code = "node MyNode\n\tposition: [100, 200]"
	var node = UMLNode.new("MyNode")
	var result = UMLParser.change_node_position(code, node, Vector2(300, 400))
	assert_true(result.contains("[300, 400]"), "Result should contain new position")
	assert_false(result.contains("[100, 200]"), "Result should not contain old position")

func test_change_node_position_new() -> void:
	var code = "node MyNode"
	var node = UMLNode.new("MyNode")
	var result = UMLParser.change_node_position(code, node, Vector2(100, 200))
	assert_true(result.contains("[100, 200]"), "Result should contain new position")

func test_change_node_position_with_decimals() -> void:
	var code = "node MyNode"
	var node = UMLNode.new("MyNode")
	var result = UMLParser.change_node_position(code, node, Vector2(123.456, 789.012))
	# Should strip trailing zeros
	assert_true(result.contains("[123.456, 789.012]"), "Result should contain position with decimals")

func test_change_node_position_with_trailing_zeros() -> void:
	var code = "node MyNode"
	var node = UMLNode.new("MyNode")
	var result = UMLParser.change_node_position(code, node, Vector2(100.0, 200.0))
	# Should strip trailing zeros and decimal point
	assert_true(result.contains("[100, 200]"), "Result should strip trailing zeros")

# ============ Find Node Declaration Tests ============

func test_find_node_declaration_exists() -> void:
	var code = "node MyNode\n\tposition: [100, 200]"
	var node = UMLNode.new("MyNode")
	var result = UMLParser.find_node_declaration(code, node)
	assert_eq(result, 0, "Should find node at line 0")

func test_find_node_declaration_not_found() -> void:
	var code = "node OtherNode"
	var node = UMLNode.new("MyNode")
	var result = UMLParser.find_node_declaration(code, node)
	assert_eq(result, -1, "Should return -1 when node not found")

func test_find_node_declaration_with_comments() -> void:
	var code = "// Comment\nnode MyNode"
	var node = UMLNode.new("MyNode")
	var result = UMLParser.find_node_declaration(code, node)
	assert_eq(result, 1, "Should find node ignoring comments")

# ============ Line Indentation Tests ============

func test_get_line_indentation_no_indent() -> void:
	var result = UMLParser.get_line_indentation("text")
	assert_eq(result, 0, "Should return 0 for no indentation")

func test_get_line_indentation_one_tab() -> void:
	var result = UMLParser.get_line_indentation("\ttext")
	assert_eq(result, 1, "Should return 1 for one tab")

func test_get_line_indentation_multiple_tabs() -> void:
	var result = UMLParser.get_line_indentation("\t\t\ttext")
	assert_eq(result, 3, "Should return 3 for three tabs")

# ============ Strip Edges and Comments Tests ============

func test_strip_end_edges_and_comments_no_comment() -> void:
	var result = UMLParser.strip_end_edges_and_comments("text   ")
	assert_eq(result, "text", "Should strip trailing whitespace")

func test_strip_end_edges_and_comments_with_comment() -> void:
	var result = UMLParser.strip_end_edges_and_comments("text // comment")
	assert_eq(result, "text", "Should remove comment")

func test_strip_end_edges_and_comments_only_comment() -> void:
	var result = UMLParser.strip_end_edges_and_comments("// comment")
	assert_eq(result, "", "Should return empty string for comment-only line")

# ============ To String Without Trailing Zeroes Tests ============

func test_to_string_without_trailing_zeroes_integer() -> void:
	var result = UMLParser.to_string_without_trailing_zeroes(100.0)
	assert_eq(result, "100", "Should remove decimal point for integers")

func test_to_string_without_trailing_zeroes_decimal() -> void:
	var result = UMLParser.to_string_without_trailing_zeroes(123.456)
	assert_eq(result, "123.456", "Should keep significant decimals")

func test_to_string_without_trailing_zeroes_trailing_zeros() -> void:
	var result = UMLParser.to_string_without_trailing_zeroes(123.4500)
	assert_eq(result, "123.45", "Should remove trailing zeros")

func test_to_string_without_trailing_zeroes_negative() -> void:
	var result = UMLParser.to_string_without_trailing_zeroes(-100.0)
	assert_eq(result, "-100", "Should handle negative integers")

# ============ Get Node By Name Tests ============

func test_get_node_by_name_exists() -> void:
	var node1 = UMLNode.new("Node1")
	var node2 = UMLNode.new("Node2")
	var diagram = UMLDiagram.new([node1, node2], [])
	var result = UMLParser.get_node_by_name(diagram, "Node1")
	assert_eq(result, node1, "Should find node by name")

func test_get_node_by_name_not_found() -> void:
	var diagram = UMLDiagram.new([], [])
	var result = UMLParser.get_node_by_name(diagram, "Unknown")
	assert_null(result, "Should return null for unknown node")

func test_get_node_by_name_multiple_nodes() -> void:
	var node1 = UMLNode.new("Node1")
	var node2 = UMLNode.new("Node2")
	var node3 = UMLNode.new("Node3")
	var diagram = UMLDiagram.new([node1, node2, node3], [])
	var result = UMLParser.get_node_by_name(diagram, "Node3")
	assert_eq(result, node3, "Should find correct node among multiple")

# ============ Complex Integration Tests ============

func test_parse_complex_diagram() -> void:
	var code = """
node Node1
	position: [100, 200]

class MyClass
	position: [300, 400]

Node1 -- MyClass
"""
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse complex diagram")
	assert_eq(result.nodes.size(), 2, "Should have two nodes")
	assert_eq(result.relationships.size(), 1, "Should have one relationship")

func test_parse_multiple_relationships() -> void:
	var code = """
node A
node B
node C
A -- B
B -- C
A -- C
"""
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should parse multiple relationships")
	assert_eq(result.relationships.size(), 3, "Should have three relationships")

func test_parse_with_empty_lines() -> void:
	var code = "node Node1\n\n\nnode Node2\n\n"
	var result = UMLParser.parse_code(code)
	assert_not_null(result, "Should handle empty lines")
	assert_eq(result.nodes.size(), 2, "Should have two nodes despite empty lines")
