extends StateMachine

@export var PUSH_FORCE: float = 10.0

func _supports(node):
	return node is RigidBody2D
	
func _integrate_forces(state: PhysicsDirectBodyState2D):
	state.apply_central_impulse(-referer.global_transform.x * PUSH_FORCE)
