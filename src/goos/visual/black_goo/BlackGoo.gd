extends "res://src/goos/visual/BaseGoo.gd"


@onready var connectable_state = $GooBody/Connectable


func _on_DraggableLimitedSpeed_drag_started():
	states.change_state("Drag")


func _on_DraggableLimitedSpeed_drag_ended():
	connectable_state.request_connection()
	

func _on_Connectable_connected(_other):
	body_states.change_state("Connected")
	states.change_state("Free")
	states.disable_group(Groups.PREVIEW_CONNECTIONS)


func _on_Connectable_connection_refused():
	body_states.change_state("Idle")
	states.change_state("Free")


func _on_Connectable_disconnected(_other):
	if connectable_state.neighbours.size() == 0:
		states.enable_group(Groups.PREVIEW_CONNECTIONS)
		body_states.change_state("Dragged")


func _on_Dragged_drag_started():
	states.change_state("Drag")


func _on_TearableOut_teared_out(_other):
	body_states.change_state("Dragged")


func _on_Dragged_drag_ended():
	connectable_state.request_connection()


func _on_TearableOut_tear_started():
	states.change_state("Teared")


func _on_TearableOut_tear_ended():
	states.change_state("Free")
