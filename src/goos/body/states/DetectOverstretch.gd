extends StateMachine

var connectable

func _supports(node):
	return node is RigidBody2D and ConnectionManager.get_connectable(node)
	
func _enter_state(previous, params = {}):
	super._enter_state(previous, params)
	connectable = ConnectionManager.get_connectable(referer)
	

func _process(_delta):
	var neighbours = connectable.neighbours
	var position = referer.global_position
	for n in neighbours:
		var g = n.referer.global_position
		if g.distance_to(position) > GameManager.MAXIMUM_DISTANCE_GOO_CONNECTION * 1.3:
			connectable.request_disconnection(n)
