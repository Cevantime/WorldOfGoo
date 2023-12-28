extends StateMachine

const PlayerRigid = preload("res://src/player/rigid/PlayerRigid.gd")

var pisto

func _supports(node):
	return node is PlayerRigid

func _enter_state(_previous, _args = {}):
	pisto = referer.get_node("PistoArea")
	pisto.enable()
	
func _exit_state(_next):
	pisto.disable()

