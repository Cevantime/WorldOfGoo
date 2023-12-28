extends StateMachine

const GrabbableArea = preload("res://src/components/GrabbableArea.gd")

@export var grabbable_area_path: NodePath

var grabbable_area: Area2D

func _supports(_node):
	return get_node(grabbable_area_path) is GrabbableArea


func _enter_state(_next, _p = {}):
	grabbable_area = get_node(grabbable_area_path)
	grabbable_area.collision_layer = Layers.PARALLEL_UNIVERSE
	grabbable_area.collision_mask = 0
	
func _exit_state(_pre):
	grabbable_area.collision_layer = Layers.PISTO_GRABBABLES
	grabbable_area.collision_mask = Layers.PISTO_VIEW_FINDERS
