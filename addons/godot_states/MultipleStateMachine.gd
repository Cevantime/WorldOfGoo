extends StateMachine
class_name MultipleStateMachine, "res://addons/godot_states/multistate_opt.svg"

func _supports(node: Node):
	return true
	
func _enter_state(previous, params = []):
	for n in get_children():
		if not(n._supports(referer)) || n.disabled:
			continue
		n.enabled = true
		n._enter_state(previous)

func _exit_state(next):
	for n in get_children():
		n.enabled = false
		n._exit_state(next)
