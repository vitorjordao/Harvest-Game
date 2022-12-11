class_name StoneHoe

var item: Item = null

func _init():
	Item.new(Item.ItemTypes.TOOLS, 100, 100, "Stone Hoe", "A simple hoe", 1)
