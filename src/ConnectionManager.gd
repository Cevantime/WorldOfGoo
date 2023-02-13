extends Node

var joint_packed = preload("res://src/connections/Connection.tscn")
var GooBody = preload("res://src/goos/BaseGooBody.gd")

onready var connection_renderer = $ConnectionsRenderer
onready var connections = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var _c = get_tree().connect("node_added", self, "_on_node_added")
	for goo in get_tree().get_nodes_in_group("goo"):
		connect_goo(goo)

func _process(_delta):
	connection_renderer.hide_connections()
	for i in range(0, connections.size()):
		var c = connection_renderer.get_connection(i)
		var joint = connections[i]
		var first = joint.node_a_instance.get_parent().sprite_rotation
		var second = joint.node_b_instance.get_parent().sprite_rotation
		connection_renderer.show_connection(c, first, second)

func _on_node_added(node):
	if node is GooBody :
		connect_goo(node)

func connect_goo(goo):
	goo.connect("drag_ended", self, "_on_goo_drag_ended", [goo])
	goo.connect("disconnected", self, "_on_goo_disconnected", [goo])
	
func _on_goo_drag_ended(goo):
	var linkable_goos = get_linkable_goos(goo)
	if linkable_goos.size() < 2:
		return
	for g in linkable_goos:
		connect_goos(goo, g)

func _on_goo_disconnected(goo):
	for neighbour in goo.neighbours:
		neighbour.neighbours.erase(goo)
		
	goo.neighbours = []
	
	for c in connections:
		if c.node_a_instance == goo or c.node_b_instance == goo:
			call_deferred("erase_connection", c)
			c.queue_free()
	
func erase_connection(c):
	connections.erase(c)
	
func check_goos_are_linkable(g, goo):
	return g != goo and not goo in g.neighbours and g.global_position.distance_to(goo.global_position) < GameManager.MAXIMUM_DISTANCE_GOO_CONNECTION

func connect_goos(g1, g2):
	var joint = joint_packed.instance()
	joint.global_position = g1.global_position
	joint.global_rotation = (g1.global_position - g2.global_position).angle() + PI / 2
	joint.length = g1.global_position.distance_to(g2.global_position)
	joint.rest_length = joint.length
	joint.node_a = g1.get_path()
	joint.node_b = g2.get_path()
	g2.add_neighbour(g1)
	g1.add_neighbour(g2)
	connections.push_back(joint)
	get_tree().get_root().add_child(joint)

func get_linkable_goos(goo):
	var linkable_goos = []
	for g in get_tree().get_nodes_in_group("goo"):
		if check_goos_are_linkable(goo, g):
			linkable_goos.push_back(g)
	return linkable_goos
