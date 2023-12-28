extends StateMachine

const BaseGooBody = preload("res://src/goos/body/BaseGooBody.gd")

var ref_angles = {}
var connectable

func _supports(node):
	return node is BaseGooBody and ConnectionManager.get_connectable(node) != null
	
	
func _enter_state(_previous, _params = {}):
	connectable = ConnectionManager.get_connectable(referer)
	for n in connectable.neighbours:
		var diff_pos = referer.global_position -  n.referer.global_position
		var nid = n.get_instance_id()
		ref_angles[nid] = {}
		for nn in n.neighbours:
			var nnid = nn.get_instance_id()
			var diff_pos_n = nn.referer.global_position - n.referer.global_position
			ref_angles[nid][nnid] = diff_pos_n.angle_to(diff_pos)
			
func _integrate_forces(_state: PhysicsDirectBodyState2D):
	pass
#	for n in connectable.neighbours:
#		var diff_pos = referer.global_position -  n.referer.global_position
#		var impulse_dir = Vector2.LEFT.rotated((-diff_pos).angle_to(diff_pos))
#		var nid = n.get_instance_id()
#		for nn in n.neighbours:
#			var nnid = nn.get_instance_id()
#			var diff_pos_n = nn.referer.global_position - n.referer.global_position
#			var ref_angle = ref_angles[nid][nnid]
#			var current_angle = diff_pos_n.angle_to(diff_pos)
#			var diff_angle = ref_angle - current_angle
#			var diff_angle_intensity = abs(diff_angle)
#			state.apply_central_impulse(diff_angle_intensity * impulse_dir * sign(diff_angle))
