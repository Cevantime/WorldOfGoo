extends "res://src/goos/visual/ConnectableGoo.gd"

@onready var blast = $SpritePosition/SpriteRotation/Blast
@onready var air_arrow = $SpritePosition/SpriteRotation/AirArrow
@onready var push_state = $GooBody/States/Started/Push
@onready var focusable = $Focusable

@export_category("Pushing")
@export_range(0, 200.0) var push_force: float = 30.0:
	set(v):
		push_force = v
		if not is_node_ready():
			await ready 
		push_state.PUSH_FORCE = v

const PurpleGoo = preload("res://src/goos/visual/purple_goo/PurpleGoo.gd")

signal connected(goo)
signal direction_set

func _ready():
	blast.material = blast.material.duplicate()

func _on_draggable_drag_ended():
	connectable.request_connection()


func _on_connect(other):
	var other_goo = other.referer.get_parent()
	
	if other_goo.is_in_group(Groups.PURPLE_GOOS):
		other_goo.connect("activated", Callable(self, "_on_activation"))
		other_goo.connect("deactivated", Callable(self, "_on_deactivation"))
		
	if states.selected_state.name == "Started":
		call_deferred("deactivate_if_inactive")
		
	

func _on_first_connect(_other):
	focusable.request_focus()


func _on_set_direction_direction_set():
	focusable.release_focus()
	switch_to_started()

func _on_activation():
	outline.show()
	start()
	
func _on_deactivation():
	outline.hide()
	stop()

func deactivate_if_inactive():
	if not check_is_active():
		_on_deactivation()

func check_is_active():
	var purple_connections = []
	# TODO: optimize
	for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
		var goo1 = pc.connectable_a
		var goo2 = pc.connectable_b
		if goo1 == connectable or goo2 == connectable:
			purple_connections.push_back(pc)
			
	if purple_connections.is_empty():
		return true
	
	for pc in purple_connections:
		var g1 = pc.connectable_a.referer.get_parent()
		var g2 = pc.connectable_b.referer.get_parent()
		if (g1 == self and g2 is PurpleGoo and g2.active) or (g2 == self and g1 is PurpleGoo and g1.active):
			return true
			
	return false

func stop():
	change_both_state("Stopped")
	
func start():
	change_both_state("Started")
	
func switch_to_started():
	var is_connected_to_purple_goo = false
	for n in connectable.neighbours:
		if n.referer.get_parent().is_in_group(Groups.PURPLE_GOOS):
			is_connected_to_purple_goo = true
			break
			
	if is_connected_to_purple_goo:
		stop()
	else:
		start()



