extends KinematicBody2D

var InventoryClass: PackedScene = preload("res://Scene/Inventory.tscn")

var inventory: Node2D = null

var is_menu_open: bool = false

onready var _animated_sprite = $AnimatedSprite
const ACCELERATION = 500
const MAX_SPEED = 150
const FRICTION = 1000

var velocity = Vector2.ZERO

var last_time_inputed = 0
func _physics_process(delta):
	_move(delta)
	_animate_walking()
	_footstep()


func _move(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

var last_key_stop_animation = "Stop Down"
func _animate_walking():
	if Input.is_action_pressed("ui_right"):
		last_key_stop_animation = "Stop Right"
		_animated_sprite.play("Run Right")
	elif Input.is_action_pressed("ui_left"):
		last_key_stop_animation = "Stop Left"
		_animated_sprite.play("Run Left")
	elif Input.is_action_pressed("ui_down"):
		last_key_stop_animation = "Stop Down"
		_animated_sprite.play("Run Down")
	elif Input.is_action_pressed("ui_up"):
		last_key_stop_animation = "Stop Up"
		_animated_sprite.play("Run Up")
	else:
		_animated_sprite.play(last_key_stop_animation)
		_animated_sprite.stop()

func _footstep():
	var isWalking = Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")
	var is_sound_played = $Footstep.playing
	if isWalking && not is_sound_played:
		$Footstep.play()
	elif not isWalking && is_sound_played:
		$Footstep.stop()
		
func _ready():
	inventory = InventoryClass.instance()
	var slot_manager
	for child in inventory.get_children():
			if child.has_signal("close"):
				slot_manager = child
	var world_objects = get_parent().get_children()
	for object in world_objects:
		if object.has_signal("get_item"):
			object.connect("get_item", slot_manager, "get_item")
		
	

func _input(ev):
	if Input.is_action_pressed("ui_inventory") and !is_menu_open:
		for child in inventory.get_children():
			if child.has_signal("close"):
				child.connect("close", self, "_close_inventory")
		add_child(inventory)
		var t = Timer.new()
		t.set_wait_time(0.3)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		is_menu_open = true
		
func _close_inventory():
	for child in inventory.get_children():
		if child.has_signal("close") && child.is_connected("close", self, "_close_inventory"):
			child.disconnect("close", self, "_close_inventory")

	remove_child(inventory)
	var t = Timer.new()
	t.set_wait_time(0.3)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	is_menu_open = false
