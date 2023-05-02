extends StateMachine

signal direction_set

func _supports(_node: Node):
	return true

func _process(_delta):
	if Input.is_action_just_pressed("set_direction"):
		emit_signal("direction_set")
