extends StateMachine

const PurpleGoo = preload("res://src/goos/visual/purple_goo/PurpleGoo.gd")

func _supports(node):
	return node is PurpleGoo
	
func _process(_delta):
	for action in ["A", "B", "X", "Y"]:
		if Input.is_action_just_pressed("action_"+action):
			referer.assign_action(action)
			return

