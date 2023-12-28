extends StateMachine

const Goo = preload("res://src/goos/visual/BaseGoo.gd")
var referer_connectable

func _supports(node):
	return node is Goo and get_connectable(node.body)
	
func _enter_state(_previous, _params = {}):
	referer_connectable = get_connectable(referer.body)
	ConnectionManager.turn_on_preview(referer_connectable)
	
func get_connectable(node):
	return ConnectionManager.get_connectable(node)
	
func _exit_state(_next):
	ConnectionManager.turn_off_preview()
	

