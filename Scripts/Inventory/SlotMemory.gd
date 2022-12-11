extends GridContainer

signal close()

var SlotClass: Resource = preload("res://Scene/Slot.tscn")

var slot_list: Array =  []

var slot_selected = null
var item_label = null

func _init():
	_set_slot_list([
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate(),
		SlotClass.instantiate()
	], 16)
	
func _input(_event):
	if Input.is_action_pressed("ui_inventory"):
		_unselect_information_item()
		emit_signal("close")
	if Input.is_action_pressed("ui_cancel") && item_label == null:
		emit_signal("close")
	
func _set_slot_list(slot_list, select_slot = 0):
	for slot in slot_list:
		slot.connect("selected_slot",Callable(self,"_select_a_slot"))
		slot.connect("get_information_item",Callable(self,"_get_information_item"))
		slot.connect("unselect_information_item",Callable(self,"_unselect_information_item"))
		add_child(slot)
	
	self.slot_list = slot_list 
	
	_select_a_slot(slot_list[select_slot])
	

func _select_a_slot(new_slot_selected):
	slot_selected = new_slot_selected
	
	for slot in slot_list:
		if slot == slot_selected:
			slot = (slot as Slot)
			slot.select()
		else:
			slot.deselect()
			
func _get_information_item(item):
	if item == null || item_label != null:
		return
	for slot in slot_list:
		slot.is_selectable = false
		
		
	var label = Label.new()
	label.text = item.description
	label.set("custom_colors/font_color", Color(0.1, 0.1, 0.1))
	
	var center_container = CenterContainer.new()
	center_container.size = Vector2(200, 40)
	center_container.add_child(label)
	
	item_label = ColorRect.new()
	item_label.size = Vector2(200, 40)
	item_label.position = Vector2(-100, -20)
	item_label.color = Color( 0.870588, 0.721569, 0.529412, 1 )
	item_label.add_child(center_container)
	
	
	self.get_parent().add_child(item_label)
	
	

func _unselect_information_item():
	for slot in slot_list:
		slot.is_selectable = true
	
	if item_label != null:
		var parent = self.get_parent()
		if parent.get_children().has(item_label):
			parent.remove_child(item_label)
		
		var t = Timer.new()
		t.set_wait_time(0.3)
		self.add_child(t)
		t.start()
		await t.timeout
		
		item_label = null

func get_item(item, quantity, item_drop):
	for slot in slot_list:
		var rest = slot.merge_items(item, quantity)
		
		if rest == null:
			item_drop.remove_item()
			return
		
		quantity = rest.quantity
	
	item_drop.quantity = quantity
