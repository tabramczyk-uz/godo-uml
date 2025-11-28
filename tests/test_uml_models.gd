extends GutTest

# ============ UMLNode Tests ============

func test_uml_node_default_init() -> void:
	var node = UMLNode.new()
	assert_eq(node.name, "Node", "Default name should be 'Node'")
	assert_eq(node.position, Vector2.ZERO, "Default position should be Vector2.ZERO")

func test_uml_node_custom_init() -> void:
	var node = UMLNode.new("CustomNode", Vector2(100, 200))
	assert_eq(node.name, "CustomNode", "Name should be set correctly")
	assert_eq(node.position, Vector2(100, 200), "Position should be set correctly")

func test_uml_node_name_only() -> void:
	var node = UMLNode.new("MyNode")
	assert_eq(node.name, "MyNode", "Name should be set")
	assert_eq(node.position, Vector2.ZERO, "Position should be default")

func test_uml_node_position_update() -> void:
	var node = UMLNode.new("Node")
	node.position = Vector2(50, 75)
	assert_eq(node.position, Vector2(50, 75), "Position should be updated")

# ============ UMLClass Tests ============

func test_uml_class_default_init() -> void:
	var uml_class = UMLClass.new()
	assert_eq(uml_class.name, "Class", "Default name should be 'Class'")
	assert_is(uml_class, UMLNode, "UMLClass should inherit from UMLNode")
	assert_eq(uml_class.attributes.size(), 0, "Should have no attributes")
	assert_eq(uml_class.methods.size(), 0, "Should have no methods")

func test_uml_class_custom_init() -> void:
	var uml_class = UMLClass.new("MyClass")
	assert_eq(uml_class.name, "MyClass", "Name should be set")
	assert_eq(uml_class.attributes.size(), 0, "Should have no attributes")
	assert_eq(uml_class.methods.size(), 0, "Should have no methods")

func test_uml_class_with_attributes_and_methods() -> void:
	var attr = UMLAttribute.new("attr1", "String")
	var method = UMLMethod.new("method1", "void")
	var uml_class = UMLClass.new("MyClass", [attr], [method])
	assert_eq(uml_class.attributes.size(), 1, "Should have one attribute")
	assert_eq(uml_class.methods.size(), 1, "Should have one method")

func test_uml_class_add_attribute() -> void:
	var uml_class = UMLClass.new("MyClass")
	var attr = UMLAttribute.new("newAttr", "Integer")
	uml_class.attributes.append(attr)
	assert_eq(uml_class.attributes.size(), 1, "Should have one attribute")
	assert_eq(uml_class.attributes[0].name, "newAttr", "Attribute name should match")

func test_uml_class_add_method() -> void:
	var uml_class = UMLClass.new("MyClass")
	var method = UMLMethod.new("newMethod", "String")
	uml_class.methods.append(method)
	assert_eq(uml_class.methods.size(), 1, "Should have one method")
	assert_eq(uml_class.methods[0].name, "newMethod", "Method name should match")

# ============ UMLAttribute Tests ============

func test_uml_attribute_default_init() -> void:
	var attr = UMLAttribute.new()
	assert_eq(attr.name, "attribute", "Default name should be 'attribute'")
	assert_eq(attr.type, "Integer", "Default type should be 'Integer'")
	assert_eq(attr.visibility, UMLParser.VISIBILITY_UNKNOWN, "Default visibility should be UNKNOWN")

func test_uml_attribute_custom_init() -> void:
	var attr = UMLAttribute.new("myAttr", "String", UMLParser.VISIBILITY_PUBLIC)
	assert_eq(attr.name, "myAttr", "Name should be set")
	assert_eq(attr.type, "String", "Type should be set")
	assert_eq(attr.visibility, UMLParser.VISIBILITY_PUBLIC, "Visibility should be set")

func test_uml_attribute_name_and_type() -> void:
	var attr = UMLAttribute.new("age", "Integer")
	assert_eq(attr.name, "age", "Name should be 'age'")
	assert_eq(attr.type, "Integer", "Type should be 'Integer'")

# ============ UMLMethod Tests ============

func test_uml_method_default_init() -> void:
	var method = UMLMethod.new()
	assert_eq(method.name, "method", "Default name should be 'method'")
	assert_eq(method.return_type, "void", "Default return type should be 'void'")
	assert_eq(method.visibility, UMLParser.VISIBILITY_UNKNOWN, "Default visibility should be UNKNOWN")
	assert_eq(method.arguments.size(), 0, "Should have no arguments")

func test_uml_method_custom_init() -> void:
	var method = UMLMethod.new("myMethod", "String", UMLParser.VISIBILITY_PUBLIC)
	assert_eq(method.name, "myMethod", "Name should be set")
	assert_eq(method.return_type, "String", "Return type should be set")
	assert_eq(method.visibility, UMLParser.VISIBILITY_PUBLIC, "Visibility should be set")

func test_uml_method_with_arguments() -> void:
	var arg = UMLMethodArgument.new("param1", "Integer")
	var method = UMLMethod.new("myMethod", "void", UMLParser.VISIBILITY_UNKNOWN, [arg])
	assert_eq(method.arguments.size(), 1, "Should have one argument")
	assert_eq(method.arguments[0].name, "param1", "Argument name should match")

func test_uml_method_add_argument() -> void:
	var method = UMLMethod.new("myMethod")
	var arg = UMLMethodArgument.new("newArg", "String")
	method.arguments.append(arg)
	assert_eq(method.arguments.size(), 1, "Should have one argument")

# ============ UMLMethodArgument Tests ============

func test_uml_method_argument_default_init() -> void:
	var arg = UMLMethodArgument.new()
	assert_eq(arg.name, "argument", "Default name should be 'argument'")
	assert_eq(arg.type, "void", "Default type should be 'void'")

func test_uml_method_argument_custom_init() -> void:
	var arg = UMLMethodArgument.new("myArg", "String")
	assert_eq(arg.name, "myArg", "Name should be set")
	assert_eq(arg.type, "String", "Type should be set")

# ============ UMLDiagram Tests ============

func test_uml_diagram_default_init() -> void:
	var diagram = UMLDiagram.new()
	assert_eq(diagram.nodes.size(), 0, "Should have no nodes")
	assert_eq(diagram.relationships.size(), 0, "Should have no relationships")

func test_uml_diagram_with_nodes() -> void:
	var node1 = UMLNode.new("Node1")
	var node2 = UMLNode.new("Node2")
	var diagram = UMLDiagram.new([node1, node2], [])
	assert_eq(diagram.nodes.size(), 2, "Should have two nodes")

func test_uml_diagram_with_relationships() -> void:
	var node1 = UMLNode.new("Node1")
	var node2 = UMLNode.new("Node2")
	var rel = UMLRelationship.new(node1, node2)
	var diagram = UMLDiagram.new([node1, node2], [rel])
	assert_eq(diagram.relationships.size(), 1, "Should have one relationship")

func test_uml_diagram_add_node() -> void:
	var diagram = UMLDiagram.new()
	var node = UMLNode.new("NewNode")
	diagram.nodes.append(node)
	assert_eq(diagram.nodes.size(), 1, "Should have one node")
	assert_eq(diagram.nodes[0].name, "NewNode", "Node name should match")

func test_uml_diagram_add_relationship() -> void:
	var diagram = UMLDiagram.new()
	var node1 = UMLNode.new("Node1")
	var node2 = UMLNode.new("Node2")
	diagram.nodes.append(node1)
	diagram.nodes.append(node2)
	var rel = UMLRelationship.new(node1, node2)
	diagram.relationships.append(rel)
	assert_eq(diagram.relationships.size(), 1, "Should have one relationship")

# ============ UMLRelationship Tests ============

func test_uml_relationship_default_init() -> void:
	var rel = UMLRelationship.new()
	assert_null(rel.from, "Default from should be null")
	assert_null(rel.to, "Default to should be null")

func test_uml_relationship_custom_init() -> void:
	var node1 = UMLNode.new("Node1")
	var node2 = UMLNode.new("Node2")
	var rel = UMLRelationship.new(node1, node2)
	assert_eq(rel.from, node1, "From should be Node1")
	assert_eq(rel.to, node2, "To should be Node2")

func test_uml_relationship_between_classes() -> void:
	var class1 = UMLClass.new("Class1")
	var class2 = UMLClass.new("Class2")
	var rel = UMLRelationship.new(class1, class2)
	assert_eq(rel.from, class1, "From should be Class1")
	assert_eq(rel.to, class2, "To should be Class2")

func test_uml_relationship_same_node() -> void:
	var node = UMLNode.new("Node")
	var rel = UMLRelationship.new(node, node)
	assert_eq(rel.from, node, "From should be the node")
	assert_eq(rel.to, node, "To should be the same node")

# ============ Integration Tests ============

func test_create_complex_diagram_structure() -> void:
	# Create classes
	var person_class = UMLClass.new("Person")
	person_class.attributes.append(UMLAttribute.new("name", "String", UMLParser.VISIBILITY_PRIVATE))
	person_class.attributes.append(UMLAttribute.new("age", "Integer", UMLParser.VISIBILITY_PRIVATE))
	person_class.methods.append(UMLMethod.new("getName", "String", UMLParser.VISIBILITY_PUBLIC))
	person_class.methods.append(UMLMethod.new("getAge", "Integer", UMLParser.VISIBILITY_PUBLIC))
	
	var company_class = UMLClass.new("Company")
	company_class.attributes.append(UMLAttribute.new("name", "String", UMLParser.VISIBILITY_PRIVATE))
	company_class.methods.append(UMLMethod.new("addEmployee", "void", UMLParser.VISIBILITY_PUBLIC, 
		[UMLMethodArgument.new("employee", "Person")]))
	
	# Create relationship
	var employment_rel = UMLRelationship.new(company_class, person_class)
	
	# Create diagram
	var diagram = UMLDiagram.new([person_class, company_class], [employment_rel])
	
	assert_eq(diagram.nodes.size(), 2, "Should have two classes")
	assert_eq(diagram.relationships.size(), 1, "Should have one relationship")
	assert_eq(person_class.attributes.size(), 2, "Person should have two attributes")
	assert_eq(person_class.methods.size(), 2, "Person should have two methods")
	assert_eq(company_class.methods[0].arguments.size(), 1, "addEmployee should have one argument")

func test_diagram_node_positions() -> void:
	var node1 = UMLNode.new("Node1", Vector2(100, 200))
	var node2 = UMLNode.new("Node2", Vector2(300, 400))
	var diagram = UMLDiagram.new([node1, node2], [])
	
	assert_eq(diagram.nodes[0].position, Vector2(100, 200), "Node1 position should be correct")
	assert_eq(diagram.nodes[1].position, Vector2(300, 400), "Node2 position should be correct")

func test_multiple_relationships_same_nodes() -> void:
	var node1 = UMLNode.new("Node1")
	var node2 = UMLNode.new("Node2")
	var rel1 = UMLRelationship.new(node1, node2)
	var rel2 = UMLRelationship.new(node2, node1)
	
	var diagram = UMLDiagram.new([node1, node2], [rel1, rel2])
	
	assert_eq(diagram.relationships.size(), 2, "Should have two relationships")
	assert_eq(diagram.relationships[0].from, node1, "First relationship from should be node1")
	assert_eq(diagram.relationships[1].from, node2, "Second relationship from should be node2")
