@tool
extends StateMachine

signal connection_requested
signal disconnection_requested
signal connected(other)
signal connection_refused
signal disconnected(other)

const GooBody = preload("res://src/goos/body/BaseGooBody.gd")

@export var visual_path: NodePath
var visual:
	get:
		if visual:
			return visual
		if visual_path:
			visual = get_node(visual_path)
			return visual
		return referer

var neighbours = []

func _enter_state(_previous, _params = {}):
	visual = get_node(visual_path) if visual_path else referer

func _supports(node):
	return node is CollisionObject2D
	
func add_neighbour(neighbour):
	neighbours.push_back(neighbour)
	
func request_connection():
	emit_signal("connection_requested")

func request_disconnection(other):
	emit_signal("disconnection_requested", other)
	
func emit_connected(other):
	emit_signal("connected", other)
	
func emit_connection_refused():
	emit_signal("connection_refused")
	
func emit_disconnected(other):
	emit_signal("disconnected", other)
