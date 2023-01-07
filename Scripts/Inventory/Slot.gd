class_name Slot extends Panel

signal selected_slot(slot)
signal get_information_item(item)
signal unselect_information_item()

var texture: TextureRect = TextureRect.new()
var label = Label.new()
var quantity = 0
var item = null
var is_selectable = true
var type_accepted_items = [Item.ItemTypes.TOOLS, Item.ItemTypes.SEED]

func _init():
	label.visible = false
	add_child(label)
	pass

	
func _can_drop_data(_at_position, data):
	var can_drop = data != null and data.item != null and type_accepted_items.has(data.item.item_type)
	if(can_drop):
		var raw_image: CompressedTexture2D = data.item.image
		var atlas_texture = get_cropped_texture(raw_image)
		Input.set_custom_mouse_cursor(atlas_texture, 7, Vector2(32, 32))
	return can_drop

func get_cropped_texture(raw_texture: Texture2D):
	var image = raw_texture.get_image()
	image.resize(32, 32)
	var texture = ImageTexture.new().create_from_image(image)
	return texture

func _drop_data(_at_position, data):
	var item = data.item
	var quantity = data.quantity
	var from_set_item = data.set_item
	var from_unset_item = data.unset_item
	
	Input.set_custom_mouse_cursor(null, 8)
	var return_data = merge_items(item, quantity)
	if(return_data == null):
		from_unset_item.call()
		return
	
	from_set_item.call(return_data.item, quantity)
	
	

func _get_drag_data(_position):
	return {"item": item, "quantity": quantity, "set_item": set_item, "unset_item": unset_item}

func _gui_input(_event):
	
	if Input.is_action_pressed("ui_select") && is_selectable:
		emit_signal("selected_slot", self)
	elif Input.is_action_pressed("ui_interact"):
		emit_signal("get_information_item", self.item)
		
func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("unselect_information_item")

func select():
	self_modulate = Color("ff11ffff")
	
func deselect():
	self_modulate = Color("00000000")


func set_item(item, quantity):
	self.item = item
	var image = item.get_image()
	texture.texture = image
	texture.ignore_texture_size = true
	texture.size = Vector2(40, 40)
	set_quantity(quantity)
	
	if !texture.get_parent() :
		add_child(texture)

func unset_item():
	
	if item:
		var old_item = self.item
		var old_quantity = self.quantity
		remove_child(texture)
		texture = TextureRect.new()
		set_quantity(0)
		self.item = null
		return { 
			"item": old_item, 
			"quantity": old_quantity,
		}
	
	return null


func merge_items(item, quantity):
	var estimated_new_quantity = self.quantity + quantity
	var is_the_same_item = is_the_same_item(item)
	var is_empty = is_empty()
	if (is_empty || is_the_same_item) && estimated_new_quantity <= item.max_quantity:
		set_item(item, self.quantity + quantity)
		return null
	elif (is_empty || is_the_same_item) && estimated_new_quantity > item.max_quantity:
		var rest_quantity = item.max_quantity - self.quantity
		set_item(item, item.max_quantity)
		return { 
			"item": item, 
			"quantity": quantity - rest_quantity,
		}
	
	return { 
		"item": item, 
		"quantity": quantity,
	}

func replace_item(item, quantity):
	var old_item = self.item
	var old_quantity = self.quantity
	set_item(item, quantity)
	return { 
		"item": old_item, 
		"quantity": old_quantity,
	}

func set_quantity(new_quantity):
	self.quantity = new_quantity
	label.text = str(self.quantity)
	
	label.visible = self.quantity > 1

func is_empty():
	return self.item == null

func is_the_same_item(item):
	return self.item != null && self.item.get_id() == item.get_id()
