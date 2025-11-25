extends LineEdit
class_name EditPopup

signal edit_finished(new_text: String)

func show_at_mouse_position(original_text: String) -> void:
	self.text = original_text
	self.position = get_viewport().get_mouse_position()
	self.show()
	self.grab_focus()
	self.select_all()

func _ready() -> void:
	self.text_submitted.connect(_on_text_submitted)
	self.editing_toggled.connect(_on_editing_toggled)

func _on_text_submitted(new_text: String) -> void:
	edit_finished.emit(new_text)
	self.hide()

func _on_editing_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		self.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		self.hide()
	elif event is InputEventMouseButton and event.pressed:
		if not self.get_global_rect().has_point(event.position):
			self.hide()
