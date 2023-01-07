class_name ItemDrop extends TextureRect

signal get_item(item, item_drop)

@export var item_resource: Resource
@export var quantity: int

var item: Item

func _ready():
	item = item_resource.new().get_item()
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
