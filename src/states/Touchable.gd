extends StateMachine

signal touched

func _supports(node: Node):
	return node is RigidBody2D
	
func _enter_state(_previous, _params = []):
	var _c = referer.connect("input_event", self, "_on_input_event")
	
func _exit_state(_next):
	referer.disconnect("input_event", self, "_on_input_event")

func _on_input_event(_viewport, event, _index):
	if event.is_action_pressed("touch"):
		emit_signal("touched")
