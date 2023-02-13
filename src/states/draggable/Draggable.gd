extends SwitchableStateMachine

signal drag_started
signal drag_ended

func _ready():
	referer.can_sleep = false
	referer.input_pickable = true

func _supports(node: Node):
	return node is RigidBody2D

func _on_Dragged_drag_ended():
	change_state("Touchable")
	emit_signal("drag_ended")


func _on_Dragged_drag_started():
	emit_signal("drag_started")


func _on_Touchable_touched():
	change_state("Dragged")
