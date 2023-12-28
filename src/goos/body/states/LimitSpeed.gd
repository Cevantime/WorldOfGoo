extends StateMachine

var entering = false

func _supports(node: Node):
	return node is RigidBody2D
	
func _enter_state(_previous, _params = {}):
	entering = true

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if entering:
		state.linear_velocity = state.linear_velocity.limit_length(200)
		entering = false
