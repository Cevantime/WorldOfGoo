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
	OK,
	TOO_CLOSE,
	TOO_FAR,
	NOT_CONNECTED,
	SAME_AS_TARGET,
	ALREADY_CONNECTED_TO_TARGET
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
	connectable.connect("connection_requested", Callable(self, "_on_connectable_connection_requested").bind(connectable))
	connectable.connect("disconnection_requested", Callable(self, "_on_connectable_disconnection_requested").bind(connectable))
	
func check_connectable_is_linkable(connectable):
	var connectables = get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE)
	
	var linkable_count = 0
	var too_close_found = false
	for c in connectables:
		var linkable_state = check_connectables_are_linkable(connectable, c)
		if linkable_state == LINKABLE_STATES.TOO_CLOSE:
			too_close_found = true
			break
		if linkable_state == LINKABLE_STATES.OK:
			linkable_count += 1
			
	return linkable_count >= 2 and not too_close_found
			
func _on_connectable_connection_requested(connectable):
	if not check_connectable_is_linkable(connectable):
		connectable.emit_connection_refused()
		return
	var linkable_connectables = get_linkable_connectables(connectable)
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
	
	for c in get_tree().get_nodes_in_group(Groups.CONNECTIONS):
		if (c.node_a_instance == goo and c.node_b_instance == other_goo) or (c.node_a_instance == other_goo and c.node_b_instance == goo):
			c.call_deferred("queue_free")
			
	connectable.emit_disconnected(other)
	other.emit_disconnected(connectable)
	
	
	
func check_connectables_are_linkable(c1, target):
	var g1 = c1.referer
	var g2 = target.referer
	
	if target.neighbours.is_empty():
		return LINKABLE_STATES.NOT_CONNECTED
	if c1 == target:
		return LINKABLE_STATES.SAME_AS_TARGET
	if c1 in target.neighbours:
		return LINKABLE_STATES.ALREADY_CONNECTED_TO_TARGET
	var distance = g1.global_position.distance_to(g2.global_position)
	if distance < GameManager.MINIMUM_DISTANCE_GOO_CONNECTION:
		return LINKABLE_STATES.TOO_CLOSE
	if distance > GameManager.MAXIMUM_DISTANCE_GOO_CONNECTION:
		return LINKABLE_STATES.TOO_FAR
	
	return LINKABLE_STATES.OK


func connect_connectables(c1, c2):
	var connection = get_connection(c1, c2)
	c2.add_neighbour(c1)
	c1.add_neighbour(c2)
	c1.emit_connected(c2)
	c2.emit_connected(c1)
	get_tree().current_scene.add_child(connection)
	
func connect_goos(goo1, goo2):
	var c1 = ConnectionManager.get_connectable(goo1.body)
	var c2 = ConnectionManager.get_connectable(goo2.body)
	connect_connectables(c1, c2)

func get_linkable_connectables(connectable):
	var linkable_connectables = []
	for c in get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE):
		if check_connectables_are_linkable(connectable, c) == LINKABLE_STATES.OK:
			linkable_connectables.push_back(c)
	return linkable_connectables
	
func get_connectable(goo):
	for child in goo.get_children():
		if child.is_in_group(Groups.CONNECTABLE_STATE):
			return child
	return null

func get_connection(c1, c2):
	for f in connection_factories:
		if f.supports(c1, c2):
			return f.get_connection(c1, c2)
	return null
