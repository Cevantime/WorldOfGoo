extends MultipleStateMachine

signal tear_started
signal tear_ended
	
	
func _on_DraggableLimitedSpeed_drag_started():
	emit_signal("tear_started")
	

func _on_DraggableLimitedSpeed_drag_ended():
	emit_signal("tear_ended")
