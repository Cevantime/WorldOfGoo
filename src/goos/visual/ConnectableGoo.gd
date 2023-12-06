extends "res://src/goos/visual/BaseGoo.gd"


func _on_connectable_connected(_other):
	body.collision_layer = body.connected_layer
	body.collision_mask = body.connected_mask


func _on_connectable_disconnected(_other):
	body.collision_layer = body.waiting_layer
	body.collision_mask = body.waiting_mask


func _on_connectable_connection_refused():
	body_states.change_state("Idle")
	states.change_state("Awake")
