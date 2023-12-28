extends StateMachine

const PlayerRigid = preload("res://src/player/rigid/PlayerRigid.gd")

func _supports(node: Node):
	return node is PlayerRigid
	
func _enter_state(_previous, _params = {} ):
	if not referer.is_connected("bonus_grabbed", Callable(self, "_on_bonus_grabbed")):
		referer.connect("bonus_grabbed", Callable(self, "_on_bonus_grabbed"))
	
func _exit_state(_next):
	referer.disconnect("bonus_grabbed", Callable(self, "_on_bonus_grabbed"))
	
func _on_bonus_grabbed(bonus):
	referer.pisto_area.grow_by_factor(bonus.extend_area_factor)
	
	bonus.grab()
	

