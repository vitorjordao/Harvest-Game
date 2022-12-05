extends GridContainer

var SlotClass = preload("res://Scene/Slot.tscn")

var slot_list: Array =  [
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance(),
	SlotClass.instance()
]

var slot_selected = null

func _ready():
	for slot in slot_list:
		slot.connect("selected_slot", self, "_select_a_slot")
		add_child(slot)
	
	_select_a_slot(slot_list[16])

func _select_a_slot(new_slot_selected):
	slot_selected = new_slot_selected
	for slot in slot_list:
		if slot == slot_selected:
			slot.select()
		else:
			slot.unselect()
