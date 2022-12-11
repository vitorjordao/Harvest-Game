class_name Item

var image: Resource = null

enum ItemTypes {
	TOOLS
}

var item_type = null

var max_life = 0
var max_quantity = 0
var current_life = 0
var name = ""
var description = ""

func _init(item_type, max_life: int, current_life: int, item_name: String, item_description: String, max_quantity: int):
	self.item_type = item_type
	self.image = (ItemsImage.ITEMS_IMAGE as Dictionary).get(item_name)
	self.max_quantity = max_quantity
	self.max_life = max_life
	self.current_life = current_life
	self.name = item_name
	self.description = item_description

func get_image():
	return image
	
func get_id():
	return str(self.name, self.description, max_life, item_type, image)
