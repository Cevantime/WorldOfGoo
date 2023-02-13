extends StateMachine

var Goo = preload("res://src/goos/visual/BaseGoo.gd")

func _supports(node):
	return node is Goo
	
func _enter_state(_previous, _params = []):
	referer.deformation_vertical_influence = 1.0
	
func _process(_delta):
	var body = referer.body
	if body.contact_count == 0:
		change_state("Free")
		return
	
	var diff_pos = referer.get_global_mouse_position() - body.global_position
	var deformation_dir = body.contact_normal.rotated(PI/2).normalized()
	
	referer.deformation = min(referer.DEFORMATION_FACTOR * diff_pos.length() * 0.01, referer.DEFORMATION_AMPLITUDE) * deformation_dir
	
