extends StateMachine

func _supports(node: Node):
	return node is RigidBody2D

func _process(_delta):
	var diff_pos = referer.get_global_mouse_position() - referer.global_position
	var angle = diff_pos.angle()
	referer.global_rotation = angle

