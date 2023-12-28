extends "res://src/goos/visual/BaseGoo.gd"

@onready var connectable = $GooBody/Connectable

func _on_connectable_connected(other):
	body.collision_layer = body.connected_layer
	body.collision_mask = body.connected_mask
	_on_connect(other)
	if connectable.neighbours.size() == 1:
		change_both_state("Connected")
		_on_first_connect(other)

func _on_connectable_disconnected(other):
	body.collision_layer = body.waiting_layer
	body.collision_mask = body.waiting_mask
	_on_disconnect(other)
	
	if connectable.neighbours.size() == 0:
		change_both_state("Awake")
		_on_last_disconnect(other)
		


func _on_connectable_connection_refused():
	change_both_state("Awake")

func _on_connect(_other):
	pass
	
func _on_first_connect(_other):
	pass
	
func _on_disconnect(_other):
	pass
	
func _on_last_disconnect(_other):
	pass

func _on_pisto_releaseable_pisto_released(_p, do_action):
	if do_action:
		connectable.request_connection()
	else:
		change_both_state("Awake")


func _on_grabbable_pisto_grabbed(p):
	change_both_state("Dragged", {"target" : p.view_finder_area})


func _on_grabbable_pisto_released(_p):
	change_both_state("Awake")
