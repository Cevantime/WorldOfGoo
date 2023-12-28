extends StateMachine

const GrabbableArea = preload("res://src/components/GrabbableArea.gd")

@export var grabbable_area: GrabbableArea

signal pisto_grabbed(p)
signal pisto_released(p)


func _supports(_node):
	return grabbable_area != null

func _enter_state(_previous, _params = {}):
	grabbable_area.connect("pisto_grabbed", Callable(self, "_on_pisto_grabbed"))
	grabbable_area.connect("pisto_released", Callable(self, "_on_pisto_released"))
	
func _exit_state(_next):
	grabbable_area.disconnect("pisto_grabbed", Callable(self, "_on_pisto_grabbed"))
	grabbable_area.disconnect("pisto_released", Callable(self, "_on_pisto_released"))

func _on_pisto_grabbed(p):
	emit_signal("pisto_grabbed", p)
	
func _on_pisto_released(p):
	emit_signal("pisto_released", p)
