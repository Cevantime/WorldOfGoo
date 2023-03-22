extends MultipleStateMachine

var connectable

signal tear_started
signal tear_ended

func _supports(node):
	return node is RigidBody2D and ConnectionManager.get_connectable(node)
	
func _enter_state(previous, params = []):
	super._enter_state(previous, params)
	connectable = ConnectionManager.get_connectable(referer)
	set_process(false)
	

func _process(_delta):
	var neighbours = connectable.neighbours
	var position = referer.global_position
	for n in neighbours:
		var g = n.referer.global_position
		if g.distance_to(position) > GameManager.MAXIMUM_DISTANCE_GOO_CONNECTION * 1.3:
			connectable.request_disconnection(n)
	

func _on_DraggableLimitedSpeed_drag_started():
	set_process(true)
	emit_signal("tear_started")
	

func _on_DraggableLimitedSpeed_drag_ended():
	set_process(false)
	emit_signal("tear_ended")
