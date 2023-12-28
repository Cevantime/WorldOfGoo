extends StateMachine

signal focus_requested(this)
signal focus_released(this)

@export var target_path: NodePath
var target

func _supports(node):
	return node is Node2D

func _enter_state(_pr, _p = {}):
	if target_path:
		target = get_node(target_path)
	else : 
		target = referer
	
func request_focus():
	emit_signal("focus_requested", self)
	
func release_focus():
	emit_signal("focus_released", self)
	
