extends "res://src/goos/visual/BaseGoo.gd"


@onready var connectable_state = $GooBody/Connectable


func _on_DraggableLimitedSpeed_drag_started():
	states.change_state("Drag")


func _on_DraggableLimitedSpeed_drag_ended():
	connectable_state.request_connection()
	

func _on_Connectable_connected(_other):
	body_states.change_state("Connected")
	states.change_state("Awake")


func _on_Connectable_connection_refused():
	body_states.change_state("Idle")
	states.change_state("Awake")


func _on_Connectable_disconnected(_other):
	if connectable_state.neighbours.size() == 0:
		body_states.change_state("Idle")


func _on_Dragged_drag_started():
	states.change_state("Drag")


func _on_Dragged_drag_ended():
	connectable_state.request_connection()

