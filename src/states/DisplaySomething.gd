extends StateMachine

@export var node_to_display_path: NodePath

var node_to_display

func _supports(_node):
	return get_node(node_to_display_path) is CanvasItem
	
func _enter_state(_pr, _p = {}):
	node_to_display = get_node(node_to_display_path)
	node_to_display.show()
	
func _exit_state(_n):
	node_to_display.hide()
