@icon("res://addons/godot_states/switchablestate_opt.svg")
extends StateMachine
class_name SwitchableStateMachine

var selected_state

func _supports(node: Node):
	return true
	
func _enter_state(previous, params = []):
	if selected_state == null:
		for n in get_children():
			if n._supports(referer) and not n.disabled:
				change_state(n.name, [null, []])
				break
			else:
				printerr("state " + n.name + " has been added to " + referer.name + " but doesn't support it!")

	elif not selected_state.disabled:
		selected_state.enabled = true
		selected_state._enter_state(previous)

func change_state(state_name, params = []):
	var next = get_node(NodePath(state_name))
	if selected_state != null:
		if selected_state == next or selected_state.disabled:
			return
		selected_state.enabled = false
		selected_state._exit_state(next)

	var previous = selected_state

	if next._supports(referer):
		selected_state = next
		selected_state.enabled = enabled
		selected_state._enter_state(previous, params)

func _exit_state(next):
	if selected_state != null :
		selected_state.enabled = false
		selected_state._exit_state(next)
		selected_state = null
