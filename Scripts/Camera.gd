extends Camera2D

export var target_path : NodePath

var target

func _ready():
	target = get_node(target_path)
	
	if target:
		position = target.position
		

func _physics_process(delta):
	if(!target):
		return
	
	position = target.position
