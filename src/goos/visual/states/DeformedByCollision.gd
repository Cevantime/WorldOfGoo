extends StateMachine

signal contact_lost

const Goo = preload("res://src/goos/visual/BaseGoo.gd")

func _supports(node):
	return node is Goo
	
func _enter_state(_previous, _params = {}):
	referer.deformation_vertical_influence = 1.0
	
func _process(_delta):
	var body = referer.body
	if body.contact_count == 0:
		emit_signal("contact_lost")
		return
	
	var diff_pos = referer.body.linear_velocity
	var deformation_dir = body.contact_normal.rotated(PI/2).normalized()
	
	referer.deformation =referer.DEFORMATION_FACTOR * diff_pos.length() * 0.001 * deformation_dir
	
