extends StateMachine

const PistoConnector = preload("res://src/weapons/pisto/PistoConnectorArea.gd")
var view_finder_area: Area2D

func _supports(node: Node):
	return node is PistoConnector
	
func _enter_state(_previous, _params = []):
	view_finder_area = referer.get_node("ViewFinderArea")
	referer.hide()
	view_finder_area.collision_layer = Layers.PARALLEL_UNIVERSE
