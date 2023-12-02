extends StateMachine

const GrabbableArea = preload("res://src/components/GrabbableArea.gd")

@export var pisto_draggable_area_path: NodePath

signal pisto_released(p)

var pisto

func _supports(_node):
	return get_node(pisto_draggable_area_path) is GrabbableArea

func _enter_state(_previous, _params = []):
	pisto = get_node(pisto_draggable_area_path)
	pisto.connect("pisto_released", Callable(self, "_on_pisto_released"))
	
func _exit_state(_next):
	referer.linear_velocity = Vector2.ZERO
	pisto.disconnect("pisto_released", Callable(self, "_on_pisto_released"))

	
func _on_pisto_released(p):
	emit_signal("pisto_released", p)
