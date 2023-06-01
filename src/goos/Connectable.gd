extends StateMachine

signal connection_requested
signal disconnection_requested
signal connected(other)
signal connection_refused
signal disconnected(other)

const GooBody = preload("res://src/goos/body/BaseGooBody.gd")

var neighbours = []

func _supports(node):
	return node is GooBody

func _enter_state(_previous, _params = []):
	referer.add_to_group(Groups.CONNECTABLE_GOO_BODIES)
	
func add_neighbour(neighbour):
	neighbours.push_back(neighbour)
	
func request_connection():
	emit_signal("connection_requested")

func request_disconnection(other):
	emit_signal("disconnection_requested", other)
	
func emit_connected(other):
	referer.collision_layer = Layers.CONNECTED_GOOS
	referer.collision_mask = Layers.GROUND + Layers.CONNECTED_GOOS
	emit_signal("connected", other)
	
func emit_connection_refused():
	emit_signal("connection_refused")
	
func emit_disconnected(other):
	referer.collision_layer = Layers.WAITING_GOOS
	referer.collision_mask = Layers.WAITING_GOOS + Layers.GROUND + Layers.SOLID_CONNECTIONS
	emit_signal("disconnected", other)
