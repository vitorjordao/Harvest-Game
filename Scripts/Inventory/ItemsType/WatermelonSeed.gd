class_name WatermelonSeed

var item: Item = null

func create_item():
	if item == null:
		item = Item.new(Item.ItemTypes.SEED, 100, 100, "WATERMELON_SEED", "A watermelon seed", 1)

func get_item():
	create_item()
	return item
