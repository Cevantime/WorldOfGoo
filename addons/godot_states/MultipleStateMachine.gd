@icon("res://addons/godot_states/multistate_opt.svg")
extends StateMachine
class_name MultipleStateMachine

func _supports(node: Node):
	return true
	
func _enter_state(previous, params = {}):
	for n in get_children():
		if not(n._supports(referer)) :
			printerr("state " + n.name + " has been added to " + referer.name + " but doesn't support it!")
			continue
		if n.disabled:
			continue
		n.enabled = true
		n._enter_state(previous, params)

func _exit_state(next):
	for n in get_children():
		n.enabled = false
		n._exit_state(next)

