extends "res://src/goos/visual/BaseGoo.gd"


@onready var connectable_state = $GooBody/Connectable
	

func _on_Connectable_connected(_other):
	body_states.change_state("Connected")
	states.change_state("Awake")


func _on_Connectable_connection_refused():
	body_states.change_state("Idle")
	states.change_state("Awake")


func _on_Connectable_disconnected(_other):
	if connectable_state.neighbours.size() == 0:
		body_states.change_state("Idle")


func _on_grabbable_pisto_grabbed(p):
	body_states.change_state("Dragged", [p.view_finder_area])
	states.change_state("Drag")


func _on_grabbable_pisto_released(_p):
	body_states.change_state("Idle")
	states.change_state("Awake")


func _on_pisto_releaseable_pisto_released(_p):
	connectable_state.request_connection()
