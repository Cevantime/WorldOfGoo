extends RigidBody2D

signal _forces_integrated

func _integrate_forces(state: PhysicsDirectBodyState2D):
	emit_signal("_forces_integrated", state)
