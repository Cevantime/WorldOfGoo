@tool
extends Control

const BaseGoo = preload("res://src/goos/visual/BaseGoo.gd")

const goo_checkbox_packed = preload("res://addons/goo_connection/GooCheckBox.tscn")

var selected_connectable = null
var selected_previous_pos = null

@onready var no_goo_selected_label = $NoGooSelectedLabel
@onready var goo_panel = $GooPanel
@onready var goo_checkboxes_v_box_container = $GooPanel/GooCheckboxesVBoxContainer
@onready var goo_not_connectable_label = $GooPanel/GooNotConnectableLabel
@onready var editor_selection = EditorInterface.get_selection()

func _ready():
	if not editor_selection.is_connected("selection_changed", Callable(self, "_on_editor_selection_changed")):
		editor_selection.connect("selection_changed", Callable(self, "_on_editor_selection_changed"))
	for connectable in get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE):
		manage_connectable_exited(connectable)
	
	get_tree().connect("node_added", Callable(self, "_on_node_added"))

func _on_node_added(node):
	if node.is_in_group(Groups.CONNECTABLE_STATE):
		manage_connectable_exited(node)

func manage_connectable_exited(connectable):
	if not connectable.is_connected("tree_exited", Callable(self, "_on_connectable_tree_exited").bind(connectable)):
		connectable.connect("tree_exited", Callable(self, "_on_connectable_tree_exited").bind(connectable))
	
func _process(delta):
	if selected_connectable:
		var should_update_checkboxes = false
		var selected_connectable_pos = _get_connectable_global_position(selected_connectable)
		if  selected_connectable_pos != selected_previous_pos:
			should_update_checkboxes = true
			selected_previous_pos = selected_connectable_pos
			
		var cls = selected_connectable.get_tree().get_nodes_in_group(Groups.CONNECTION_LINES)
		var selected_connectable_rotation = _get_connectable_sprite_rotation(selected_connectable)
		for cl in cls:
			if selected_connectable_rotation == cl.node_a_instance:
				if not (ConnectionManager.check_connectables_are_linkable(selected_connectable, cl.connectable_b) & (ConnectionManager.LINKABLE_STATES.OK | ConnectionManager.LINKABLE_STATES.NOT_CONNECTED)):
					cl.queue_free()
					should_update_checkboxes = true
			if selected_connectable_rotation == cl.node_b_instance:
				if not (ConnectionManager.check_connectables_are_linkable(selected_connectable, cl.connectable_a)  & (ConnectionManager.LINKABLE_STATES.OK | ConnectionManager.LINKABLE_STATES.NOT_CONNECTED)):
					cl.queue_free()
					should_update_checkboxes = true
		if should_update_checkboxes:
			update_checkboxes()
					
				
				
func _get_connectable_global_position(connectable):
	return _get_connectable_sprite_rotation(connectable).global_position
	
func _get_connectable_sprite_rotation(connectable):
	return connectable.visual
	
func _get_sprite_rotation_connectable(sprite_rotation):
	return ConnectionManager.get_connectable(sprite_rotation.get_parent().get_parent().get_node("GooBody"))
	
func _on_editor_selection_changed():
	var selected_nodes = editor_selection.get_selected_nodes()
	if selected_nodes.size() != 1:
		goo_panel.visible = false
		no_goo_selected_label.visible = true
		if selected_connectable != null:
			deselect_connectable()
		return
	var selected = selected_nodes[0]
	selected_connectable = ConnectionManager.search_connectable(selected, 2)
	goo_panel.visible = selected_connectable != null
	no_goo_selected_label.visible = ! goo_panel.visible
	if goo_panel.visible:
		selected_previous_pos = _get_connectable_global_position(selected_connectable)
		update_checkboxes()
		
	elif selected_connectable != null:
		deselect_connectable()

func deselect_connectable():
	selected_connectable = null
	
func update_checkboxes():
	if selected_connectable:
		var possible_neighbours: Array = ConnectionManager.get_linkable_connectables(selected_connectable, ConnectionManager.LINKABLE_STATES.OK | ConnectionManager.LINKABLE_STATES.NOT_CONNECTED)
		var no_possible_neighbours = possible_neighbours.is_empty()
		goo_not_connectable_label.visible = no_possible_neighbours
		goo_checkboxes_v_box_container.visible = !goo_not_connectable_label.visible
		for c in goo_checkboxes_v_box_container.get_children():
			c.queue_free()
		if not no_possible_neighbours:
			for c in possible_neighbours:
				var checkbox = goo_checkbox_packed.instantiate()
				checkbox.connectable_ref = c
				checkbox.text = c.referer.get_parent().name
				goo_checkboxes_v_box_container.add_child(checkbox)
				checkbox.button_pressed = check_are_connected(c, selected_connectable)
				checkbox.connect("toggled", Callable(self, "_on_checkbox_toggled").bind(checkbox))
				
func _on_connectable_tree_exited(connectable):
	var selected_connectable_rotation = _get_connectable_sprite_rotation(connectable)
	for c in get_tree().get_nodes_in_group(Groups.CONNECTION_LINES):
		if c.node_a_instance == selected_connectable_rotation or c.node_b_instance == selected_connectable_rotation:
			c.queue_free()

func check_are_connected(c1, c2):
	var cls = c1.get_tree().get_nodes_in_group(Groups.CONNECTION_LINES)
	for cl in cls:
		if is_connectable_between(cl, c1, c2):
			return true
	return false

func is_connectable_between(cl, c1, c2):
	var n1 = _get_connectable_sprite_rotation(c1)
	var n2 = _get_connectable_sprite_rotation(c2)
	return cl.node_a_instance in [n1, n2] && cl.node_b_instance in [n1, n2]

func _on_checkbox_toggled(toggled, checkbox):
	var states = ConnectionManager.LINKABLE_STATES
	if toggled && selected_connectable && ConnectionManager.check_connectables_are_linkable(selected_connectable, checkbox.connectable_ref) & (states.OK | states.NOT_CONNECTED):
		var c1 = selected_connectable
		var c2 = checkbox.connectable_ref
		var connection_factory = ConnectionManager.get_factory(c1, c2)
		var connection_line: Node = connection_factory._create_default_connection_line(c1, c2)
		var scene_root = EditorInterface.get_edited_scene_root()
		scene_root.add_child(connection_line)
		connection_line.set_meta("_edit_lock_", true)
		connection_line.owner = scene_root
		connection_line.connectable_a_path = connection_line.get_path_to(connection_line.connectable_a)
		connection_line.connectable_b_path = connection_line.get_path_to(connection_line.connectable_b)
		
	elif not toggled && selected_connectable:
		var c1 = selected_connectable
		var c2 = checkbox.connectable_ref
		var cls = c1.get_tree().get_nodes_in_group(Groups.CONNECTION_LINES)
		for cl in cls:
			if is_connectable_between(cl, c1, c2):
				cl.queue_free()
