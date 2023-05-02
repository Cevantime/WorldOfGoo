extends StateMachine


const Goo = preload("res://src/goos/visual/BaseGoo.gd")

func _supports(node):
	return node is Goo
