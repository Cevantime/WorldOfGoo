extends StateMachine

var GooBody = preload("res://src/goos/GooBody.gd")

func _supports(node: Node):
	return node is GooBody
	
func _enter_state(_previous, _params = []):
	referer.add_to_group(Groups.CONNECTED_GOOS)
	
func _exit_state(_next):
	referer.remove_from_group(Groups.CONNECTED_GOOS)
