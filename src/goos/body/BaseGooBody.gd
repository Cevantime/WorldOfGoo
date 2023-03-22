extends RigidBody2D

signal _forces_integrated

@export var contact_normal = Vector2.UP

var contact_count = 0
var contact_position

func _integrate_forces(state):
	contact_count = state.get_contact_count()
	contact_normal = Vector2.UP
	contact_position = null
	for i in range(0, contact_count):
		var contact = state.get_contact_collider_object(i)
		if contact is StaticBody2D:
			contact_position = state.get_contact_local_position(i)
			contact_normal = state.get_contact_local_normal(i)
			break
	
	emit_signal("_forces_integrated", state)

