extends Resource
class_name UMLClass

@export var name: String = "Class"
# @export var attributes: Array = []
# @export var methods: Array = []

func _init(p_name: String = "Class"):
	name = p_name

	self.changed.connect(func():
		self.emit_changed()
		print("Changed UMLClass: %s" % name)
	)
