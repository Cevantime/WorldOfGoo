extends StateMachine

const BaseGooBody = preload("res://src/goos/body/BaseGooBody.gd")

func _supports(node: Node):
	return node is BaseGooBody

func _enter_state(_previous, _params = {}):
	referer.collision_layer = referer.dragging_layer
	referer.collision_mask = referer.dragging_mask

func _exit_state(_next):
	referer.collision_layer = referer.waiting_layer
	referer.collision_mask = referer.waiting_mask
