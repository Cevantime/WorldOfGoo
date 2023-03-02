extends StateMachine


var Goo = preload("res://src/goos/visual/BaseGoo.gd")

func _supports(node):
	return node is Goo
