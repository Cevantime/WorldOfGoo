extends SwitchableStateMachine


signal drag_started
signal drag_ended


func _on_Dragged_drag_started():
	emit_signal("drag_started")


func _on_Dragged_drag_ended():
	change_state("TouchableLimitedSpeed")
	emit_signal("drag_ended")


func _on_Touchable_touched():
	change_state("Dragged")
