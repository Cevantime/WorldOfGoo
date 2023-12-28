extends StateMachine

var initial_rotation
var ref_neighbours_vectors = {}
var connectable

func _supports(node: Node):
	return ConnectionManager.get_connectable(node) != null


func _enter_state(_previous, _params = {}):
	connectable = ConnectionManager.get_connectable(referer)
	set_refs()
	connectable.connect("disconnected", Callable(self, "_on_disconnected"))
	connectable.connect("connected", Callable(self, "_on_connected"))

func _exit_state(_next):
	connectable.disconnect("disconnected", Callable(self, "_on_disconnected"))
	connectable.disconnect("connected", Callable(self, "_on_connected"))

func _on_disconnected(_other):
	set_refs()

func _on_connected(_other):
	set_refs()
	
func set_refs():
	if connectable.neighbours.size() == 0:
		return
	
	initial_rotation = referer.global_rotation
	
	for n in connectable.neighbours:
		ref_neighbours_vectors[n.get_instance_id()] = n.referer.global_position - referer.global_position
	
	
func compute_average_diff_angle():
	var diff_angle = 0
	for n in connectable.neighbours:
		diff_angle += ref_neighbours_vectors[n.get_instance_id()].angle_to(n.referer.global_position - referer.global_position)
	
	return diff_angle / connectable.neighbours.size()
	
func _integrate_forces(state: PhysicsDirectBodyState2D):
	if connectable.neighbours.size() == 0:
		return
		
	var angle = compute_average_diff_angle() + initial_rotation
	state.angular_velocity = (angle - referer.global_rotation) / state.get_step()
