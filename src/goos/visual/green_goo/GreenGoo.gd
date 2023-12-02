extends "res://src/goos/visual/BaseGoo.gd"

@onready var connectable_state = $GooBody/Connectable
@onready var blast = $SpritePosition/SpriteRotation/Blast
@onready var air_arrow = $SpritePosition/SpriteRotation/AirArrow
@onready var push_state = $GooBody/States/Started/Push

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
	connectable_state.request_connection()


func _on_connectable_connection_refused():
	states.change_state("Awake")
	body_states.change_state("Idle")


func _on_connectable_connected(other):
	var other_goo = other.referer.goo
	
	if other_goo.is_in_group(Groups.PURPLE_GOOS):
		other_goo.connect("activated", Callable(self, "_on_activation"))
		other_goo.connect("deactivated", Callable(self, "_on_deactivation"))
		call_deferred("deactivate_in_inactive")
		
	if connectable_state.neighbours.size() >=2:
		return
		
	emit_signal("connected", self)

func switch_to_just_connected():
	air_arrow.show()
	body_states.change_state("JustConnected")
	states.change_state("JustConnected")

func _on_set_direction_direction_set():
	emit_signal("direction_set")

func _on_activation():
	outline.show()
	start()
	
func _on_deactivation():
	outline.hide()
	stop()

func deactivate_in_inactive():
	if not check_is_active():
		_on_deactivation()

func check_is_active():
	var purple_connections = []
	# TODO: optimize
	for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
		var goo1 = pc.goo_a
		var goo2 = pc.goo_b
		if goo1 == self or goo2 == self:
			purple_connections.push_back(pc)
			
	if purple_connections.is_empty():
		return true
	
	for pc in purple_connections:
		var g1 = pc.goo_a
		var g2 = pc.goo_b
		if (g1 == self and g2 is PurpleGoo and g2.active) or (g2 == self and g1 is PurpleGoo and g1.active):
			return true
			
	return false

func stop():
	states.change_state("Stopped")
	body_states.change_state("Stopped")
	
func start():
	states.change_state("Started")
	body_states.change_state("Started")
	
func switch_to_started():
	air_arrow.hide()
	var is_connected_to_purple_goo = false
	for n in connectable_state.neighbours:
		if n.referer.goo.is_in_group(Groups.PURPLE_GOOS):
			is_connected_to_purple_goo = true
			break
			
	if is_connected_to_purple_goo:
		stop()
	else:
		start()

func _on_connectable_disconnected(_other):
	if connectable_state.neighbours.size() == 0:
		body_states.change_state("Idle")



func _on_pisto_grabbable_pisto_grabbed(p):
	body_states.change_state("Dragged", [p.view_finder_area])
	states.change_state("Dragged")


func _on_pisto_grabbable_pisto_released(_p):
	body_states.change_state("Idle")
	states.change_state("Awake")


func _on_pisto_releaseable_pisto_released(_p):
	connectable_state.request_connection()
