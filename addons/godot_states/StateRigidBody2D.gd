extends RigidBody2D

signal _forces_integrated

func _integrate_forces(state):
	emit_signal("_forces_integrated", state)
