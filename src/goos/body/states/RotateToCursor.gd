extends StateMachine

var ROTATION_SPEED := 3.0

func _supports(node: Node):
	return node is RigidBody2D

func _process(delta):
	var rotation = Input.get_axis("rotate_green_goo_left", "rotate_green_goo_right")
	referer.global_rotation += rotation * delta * ROTATION_SPEED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		referer.global_rotation = referer.global_position.angle_to_point(referer.get_global_mouse_position())
