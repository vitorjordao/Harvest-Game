class_name ItemDrop extends TextureRect

signal get_item(item, item_drop)

@export var item_type: Item.ItemTypes # (Item.ItemTypes)
@export var max_life: int
@export var current_life: int
@export var item_name: String
@export var item_description: String
@export var max_quantity: int
@export var quantity: int

var item: Item

func _ready():
	item = Item.new(item_type, max_life, current_life, item_name, item_description, max_quantity)
	texture = item.get_image()
	ignore_texture_size = true
	size = Vector2(20, 20)
	
func _gui_input(_event):
	if Input.is_action_pressed("ui_select"):
		_get_item()
		
func _get_item():
	emit_signal("get_item", item, quantity, self)
	
func remove_item():
	self.get_parent().remove_child(self)
