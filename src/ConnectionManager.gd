extends Node

var joint_packed = preload("res://src/connections/Connection.tscn")
var GooBody = preload("res://src/goos/body/BaseGooBody.gd")
var Goo = preload("res://src/goos/visual/BaseGoo.gd")

@onready var connection_renderer = $ConnectionsRenderer
@onready var connections = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var _c = get_tree().connect("node_added", Callable(self, "_on_node_added"))
	for connectable_state in get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE):
		listen_to_connectable(connectable_state)

func _process(_delta):
	connection_renderer.hide_connections()
	for i in range(0, connections.size()):
		var c = connection_renderer.get_connection(i)
		var joint = connections[i]
		var first = joint.node_a_instance.get_parent().sprite_rotation
		var second = joint.node_b_instance.get_parent().sprite_rotation
		connection_renderer.show_connection(c, first, second)

func _on_node_added(node: Node):
	if node.is_in_group(Groups.CONNECTABLE_STATE):
		listen_to_connectable(node)

func listen_to_connectable(connectable):
	connectable.connect("connection_requested", Callable(self, "_on_connectable_connection_requested").bind(connectable))
	connectable.connect("disconnection_requested", Callable(self, "_on_connectable_disconnection_requested").bind(connectable))
	
func _on_connectable_connection_requested(connectable):
	var linkable_connectables = get_linkable_connectables(connectable)
	if linkable_connectables.size() < 2:
		connectable.emit_connection_refused()
		return
	for c in linkable_connectables:
		connect_connectables(connectable, c)

func _on_connectable_disconnection_requested(connectable, other):
	if not other in connectable.neighbours:
		printerr("requested disconnection between goos that are not connected")
		return
		
	other.neighbours.erase(connectable)
	connectable.neighbours.erase(other)
	
	var goo = connectable.referer
	var other_goo = other.referer
	
	for c in connections:
		if (c.node_a_instance == goo and c.node_b_instance == other_goo) or (c.node_a_instance == other_goo and c.node_b_instance == goo):
			call_deferred("erase_connection", c)
			c.queue_free()
			
	connectable.emit_disconnected( other)
	other.emit_disconnected( connectable)
	
func erase_connection(c):
	connections.erase(c)
	
func check_connectables_are_linkable(c1, c2):
	var g1 = c1.referer
	var g2 = c2.referer
	return c1 != c2 and not c1 in c2.neighbours and g1.global_position.distance_to(g2.global_position) < GameManager.MAXIMUM_DISTANCE_GOO_CONNECTION

func connect_connectables(c1, c2):
	var joint = joint_packed.instantiate()
	var g1 = c1.referer
	var g2 = c2.referer
	joint.global_position = g1.global_position
	joint.global_rotation = (g1.global_position - g2.global_position).angle() + PI / 2
	joint.length = g1.global_position.distance_to(g2.global_position)
	joint.rest_length = joint.length
	joint.node_a = g1.get_path()
	joint.node_b = g2.get_path()
	c2.add_neighbour(c1)
	c1.add_neighbour(c2)
	c1.emit_connected(c2)
	c2.emit_connected(c1)
	connections.push_back(joint)
	get_tree().current_scene.call_deferred("add_child", joint)

func get_linkable_connectables(connectable):
	var linkable_connectables = []
	for c in get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE):
		if check_connectables_are_linkable(connectable, c):
			linkable_connectables.push_back(c)
	return linkable_connectables
	
func get_connectable(goo):
	for child in goo.get_children():
		if child.is_in_group(Groups.CONNECTABLE_STATE):
			return child
	return null
