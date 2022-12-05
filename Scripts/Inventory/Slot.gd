extends Panel

signal selected_slot(slot)

func _ready():
	pass

func _gui_input(event):
	if Input.is_action_pressed("ui_select"):
		emit_signal("selected_slot", self)

func select():
	self_modulate = Color("e6ff0055")
	
func unselect():
	self_modulate = Color("ffffff55")
