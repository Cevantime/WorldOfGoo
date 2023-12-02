extends StateMachine

@export var extend_area_factor: float = 1.0

signal disappeared

func _supports(_node: Node):
	return true
	
func _enter_state(_previous, _params = []):
	referer.add_to_group(Groups.BONUS)
	
func _exit_state(_next):
	referer.remove_from_group(Groups.BONUS)

func grabbed_by(player):
	player.grab_bonus(self)

func disappear():
	emit_signal("disappeared")
