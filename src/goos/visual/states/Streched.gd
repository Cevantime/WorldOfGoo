extends StateMachine

const Goo = preload("res://src/goos/visual/BaseGoo.gd")

var connectable
var initial_neighbours_diff

func _supports(node):
	return node is Goo
	
func _enter_state(_previous, _params = []):
	connectable = ConnectionManager.get_connectable(referer.body)
	initial_neighbours_diff = {}
	var body = referer.body
	for n in connectable.neighbours:
		var other_body = n.referer
		initial_neighbours_diff[n.get_instance_id()] = (body.global_position - other_body.global_position).length()
	

func _process(_delta):
	var body = referer.body
	var stretch_direction = Vector2.ZERO
	var global_diff = Vector2.ZERO
	for n in connectable.neighbours:
		var other_body = n.referer
		var diff = body.global_position - other_body.global_position
		global_diff += diff
		stretch_direction += diff - diff.normalized() * initial_neighbours_diff[n.get_instance_id()]
		
	stretch_direction /= connectable.neighbours.size()
	if stretch_direction.dot(global_diff) < 0:
		stretch_direction = stretch_direction.rotated(PI / 2)
	referer.deformation += stretch_direction * 0.005 * referer.DEFORMATION_FACTOR
