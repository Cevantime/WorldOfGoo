extends StateMachine

const GreenGoo = preload("res://src/goos/visual/green_goo/GreenGoo.gd")

func _supports(node):
	return node is GreenGoo

func _enter_state(_p, _params = {}):
	referer.air_arrow.show()
	
func _exit_state(_n):
	referer.air_arrow.hide()
