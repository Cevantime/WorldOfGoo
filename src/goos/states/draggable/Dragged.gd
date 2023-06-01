extends StateMachine

signal drag_started
signal drag_ended


func _supports(node: Node):
	return node is RigidBody2D

func _integrate_forces(state: PhysicsDirectBodyState2D):
	var r = referer as RigidBody2D
	var mouse_pos = r.get_global_mouse_position()
	var diff_pos = mouse_pos - r.global_position
	state.linear_velocity = diff_pos * 30
	if state.get_contact_count() > 0:
		state.linear_velocity = state.linear_velocity.limit_length(400)
	
func _input(event):
	if event.is_action_released("touch"):
		emit_signal("drag_ended")
	
	
func _enter_state(_previous, _params = []):
	referer.collision_layer = Layers.DRAGGED_GOOS
	referer.collision_mask = Layers.GROUND
	emit_signal("drag_started")

func _exit_state(_next):
	referer.collision_layer = Layers.WAITING_GOOS
	referer.collision_mask = Layers.WAITING_GOOS + Layers.GROUND + Layers.SOLID_CONNECTIONS
