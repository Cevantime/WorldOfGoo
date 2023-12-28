extends StateMachine

const GrabbableArea = preload("res://src/components/GrabbableArea.gd")

@export var grabbable_area: GrabbableArea

signal pisto_released(p, do_action)


func _supports(_node):
	return grabbable_area != null

func _enter_state(_previous, _params = {}):
	grabbable_area.connect("pisto_released", Callable(self, "_on_pisto_released"))
	
func _exit_state(_next):
	referer.linear_velocity = Vector2.ZERO
	grabbable_area.disconnect("pisto_released", Callable(self, "_on_pisto_released"))

	
func _on_pisto_released(p, do_action = true):
	emit_signal("pisto_released", p, do_action)
