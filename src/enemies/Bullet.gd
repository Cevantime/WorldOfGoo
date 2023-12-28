@tool
extends RigidBody2D

@export var SPEED: float = 50.0

var velocity
var contact_lost = true


func _integrate_forces(state):
	state.linear_velocity = velocity * SPEED
	var contact_count =  state.get_contact_count()
	if contact_count > 0 and contact_lost:
		contact_lost = false
		var should_be_deleted = true
		for i in range(contact_count):
			var body = state.get_contact_collider_object(i)
			if body.is_in_group(Groups.BULLET_REFLECTORS):
				var normal = state.get_contact_local_normal(i)
				velocity = velocity.bounce(normal)
				should_be_deleted = false
			elif body.has_method("burn"):
				body.burn()
				
		if should_be_deleted :
			queue_free()
			
	elif contact_count == 0:
		contact_lost = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
