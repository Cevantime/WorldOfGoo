extends StateMachine

const PlayerRigid = preload("res://src/player/rigid/PlayerRigid.gd")

func _supports(node):
	return node is PlayerRigid
	
func _enter_state(_previous, _params = {}):
	referer.connect("rope_visited", Callable(self, "_on_rope_visited"))
	
func _exit_state(_next):
	referer.disconnect("rope_visited", Callable(self, "_on_rope_visited"))

func _on_rope_visited(rope):
	rope.linear_velocity = referer.linear_velocity
	change_state("BeforeRope", {"target": rope})
