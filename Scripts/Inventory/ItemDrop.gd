class_name ItemDrop extends TextureRect

signal get_item(item, item_drop)

export(Item.ItemTypes) var item_type
export var max_life: int
export var current_life: int
export var item_name: String
export var item_description: String
export var max_quantity: int
export var quantity: int

var item: Item

func _ready():
	item = Item.new(item_type, max_life, current_life, item_name, item_description, max_quantity)
	texture = item.get_image()
	expand = true
	rect_size = Vector2(20, 20)
	
func _gui_input(event):
	if Input.is_action_pressed("ui_select"):
		_get_item()
		
func _get_item():
	print("Quantidade: ", quantity)
	emit_signal("get_item", item, quantity, self)
	
func remove_item():
	self.get_parent().remove_child(self)
