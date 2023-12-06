@tool
extends Node

var GooBody = preload("res://src/goos/body/BaseGooBody.gd")
var Goo = preload("res://src/goos/visual/BaseGoo.gd")

var connectable_previewed
var preview_links = {}

class PreviewLink:
	var preview_line
	var connectable
	func _init(p, c):
		preview_line = p
		connectable = c

enum LINKABLE_STATES {
	OK = 1,
	TOO_CLOSE = 2,
	TOO_FAR = 4,
	NOT_CONNECTED = 8,
	SAME_AS_TARGET = 16,
	ALREADY_CONNECTED_TO_TARGET = 32
}

@onready var connection_factories = $ConnectionFactories.get_children()

signal connection_done(joint, c1, c2)

func _process(_delta):
	for preview_link in preview_links.values():
		var preview_line = preview_link.preview_line
		var connectable = preview_link.connectable
		if check_connectables_are_linkable(connectable_previewed, connectable) != LINKABLE_STATES.OK:
			preview_line.call_deferred("queue_free")
			preview_links.erase(connectable.get_instance_id())
		
	var connectables = get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE)
			
	if not check_connectable_is_linkable(connectable_previewed):
		for preview_link in preview_links.values():
			preview_link.preview_line.hide()
		return
	else:
		for preview_link in preview_links.values():
			preview_link.preview_line.display()
			
	for c in connectables:
		if check_connectables_are_linkable(connectable_previewed, c) == LINKABLE_STATES.OK and not preview_links.has(c.get_instance_id()):
			var preview_line = get_preview_line(connectable_previewed, c)
			get_tree().current_scene.add_child(preview_line)
			preview_links[c.get_instance_id()] = PreviewLink.new(preview_line, c)
			
	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	var _c = get_tree().connect("node_added", Callable(self, "_on_node_added"))
	for connectable_state in get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE):
		listen_to_connectable(connectable_state)
	
func get_preview_line(c1, c2):
	return get_factory(c1, c2).get_preview_line(c1, c2)

func get_factory(c1, c2):
	for f in connection_factories:
		if f.supports(c1, c2):
			return f
	return null

func turn_on_preview(c):
	connectable_previewed = c
	set_process(true)
	
func turn_off_preview():
	connectable_previewed = null
	set_process(false)
	for p in preview_links.values():
		var preview_line = p.preview_line
		var connectable = p.connectable
		preview_line.call_deferred("queue_free")
		preview_links.erase(connectable.get_instance_id())
	preview_links = {}

func _on_node_added(node: Node):
	if node.is_in_group(Groups.CONNECTABLE_STATE):
		listen_to_connectable(node)

func listen_to_connectable(connectable):
	if not connectable.is_connected("connection_requested", Callable(self, "_on_connectable_connection_requested").bind(connectable)):
		connectable.connect("connection_requested", Callable(self, "_on_connectable_connection_requested").bind(connectable))
		connectable.connect("disconnection_requested", Callable(self, "_on_connectable_disconnection_requested").bind(connectable))
	
func check_connectable_is_linkable(connectable):
	var connectables = get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE)
	
	var linkable_count = 0
	
	for c in connectables:
		var linkable_state = check_connectables_are_linkable(connectable, c)
		if linkable_state == LINKABLE_STATES.TOO_CLOSE:
			return false
		if linkable_state == LINKABLE_STATES.OK:
			linkable_count += 1
			
	return linkable_count >= GameManager.MINIMUM_LINK_COUNT_AT_CREATION
			
func _on_connectable_connection_requested(connectable):
	if not check_connectable_is_linkable(connectable):
		connectable.emit_connection_refused()
		return
	var linkable_connectables = get_linkable_connectables(connectable)
	for c in linkable_connectables:
		connect_connectables(connectable, c)

func disconnect_connectables(connectable, other):
	if not other in connectable.neighbours:
		printerr("requested disconnection between goos that are not connected")
		return
		
	other.neighbours.erase(connectable)
	connectable.neighbours.erase(other)
	
	var goo = connectable.referer
	var other_goo = other.referer
	
	for c in get_tree().get_nodes_in_group(Groups.CONNECTIONS):
		if (c.node_a_instance == goo and c.node_b_instance == other_goo) or (c.node_a_instance == other_goo and c.node_b_instance == goo):
			c.call_deferred("queue_free")
			
	connectable.emit_disconnected(other)
	other.emit_disconnected(connectable)
	
func _on_connectable_disconnection_requested(connectable, other):
	disconnect_connectables(connectable, other)
	
	
func check_connectables_are_linkable(c1, target):
	var g1 = c1.referer
	var g2 = target.referer
	if c1 == target:
		return LINKABLE_STATES.SAME_AS_TARGET
		
	if c1 in target.neighbours:
		return LINKABLE_STATES.ALREADY_CONNECTED_TO_TARGET
		
	var max_dist = GameManager.MAXIMUM_DISTANCE_GOO_CONNECTION
	
	var distance_squared = g1.global_position.distance_squared_to(g2.global_position)
	if distance_squared > max_dist * max_dist:
		return LINKABLE_STATES.TOO_FAR
	var min_dis = GameManager.MINIMUM_DISTANCE_GOO_CONNECTION
	if distance_squared < min_dis * min_dis:
		return LINKABLE_STATES.TOO_CLOSE
	
	if target.neighbours.is_empty():
		return LINKABLE_STATES.NOT_CONNECTED
		
	return LINKABLE_STATES.OK


func connect_connectables(c1, c2):
	var connection = get_connection(c1, c2)
	c2.add_neighbour(c1)
	c1.add_neighbour(c2)
	c1.emit_connected(c2)
	c2.emit_connected(c1)
	get_tree().current_scene.add_child(connection)
	return connection
	

func get_linkable_connectables(connectable, condition = LINKABLE_STATES.OK):
	var linkable_connectables = []
	for c in get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE):
		if check_connectables_are_linkable(connectable, c) & condition:
			linkable_connectables.push_back(c)
	return linkable_connectables
	
func get_connectable(goo):
	for child in goo.get_children():
		if child.is_in_group(Groups.CONNECTABLE_STATE):
			return child
	return null

func search_connectable(node: Node, max_depth, current_depth = 0):
	if current_depth == max_depth:
		return null
	for child in node.get_children():
		if child.is_in_group(Groups.CONNECTABLE_STATE):
			return child
		else:
			var searched = search_connectable(child, max_depth, current_depth + 1)
			if searched:
				return searched
	
	return null
	
func get_connection(c1, c2):
	for f in connection_factories:
		if f.supports(c1, c2):
			return f.get_connection(c1, c2)
	return null
