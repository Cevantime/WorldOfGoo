extends StateMachine

@export var target_path:NodePath

var target

func _supports(node: Node):
	return node is RigidBody2D

func _integrate_forces(state: PhysicsDirectBodyState2D):
	var r = referer as RigidBody2D
	var target_pos = target.global_position if target else r.get_global_mouse_position()
	var diff_pos = target_pos - r.global_position
	state.linear_velocity = diff_pos * 30
	if state.get_contact_count() > 0:
		state.linear_velocity = state.linear_velocity.limit_length(400)
	
	
func _enter_state(_previous, params = {}):
	if params.has("target"):
		target = params.target
	elif target_path:
		target = get_node(target_path)
	else:
		target = null
		

