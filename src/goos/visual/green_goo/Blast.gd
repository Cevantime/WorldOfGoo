extends StateMachine

const GreenGoo = preload("res://src/goos/visual/green_goo/GreenGoo.gd")

var animation_player

func _supports(node):
	return node is GreenGoo

func _enter_state(_previous, _params = []):
	animation_player = referer.get_node("AnimationPlayer")
	animation_player.play("start_blast")
	
func _exit_state(_next_state):
	animation_player.play("stop_blast")
