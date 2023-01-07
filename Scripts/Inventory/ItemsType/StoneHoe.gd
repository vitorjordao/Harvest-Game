class_name StoneHoe

var item: Item = null

func create_item():
	if item == null:
		item = Item.new(Item.ItemTypes.TOOLS, 100, 100, "STONE_HOE", "A simple hoe", 1)

func get_item():
	create_item()
	return item
