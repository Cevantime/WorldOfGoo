extends StateMachine

const GooBody = preload("res://src/goos/body/BaseGooBody.gd")

func _supports(node: Node):
	return node is GooBody
	
func _enter_state(_previous, _params = []):
	referer.add_to_group(Groups.CONNECTABLE_GOO_BODIES)
	
func _exit_state(_next):
	referer.remove_from_group(Groups.CONNECTABLE_GOO_BODIES)
