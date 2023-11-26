extends RigidBody2D

signal _forces_integrated

@export var JUMP_FORCE = 100
@export var VELOCITY = 100
@export var MAXIMUM_HORIZONTAL_VELOCITY = 200.0

var maximum_h_velocity = 0.0

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if Input.is_action_just_pressed("ui_accept") and can_jump(state):
		state.apply_central_impulse(Vector2.UP * JUMP_FORCE)
		
	var input_h = Input.get_axis("ui_left", "ui_right")
	state.apply_central_impulse(Vector2.RIGHT * input_h * VELOCITY)
	
	
	if is_on_wall(state) or input_h != 0:
		physics_material_override.friction = 0
	else:
		physics_material_override.friction = 5
		
	if input_h != 0:
		maximum_h_velocity = MAXIMUM_HORIZONTAL_VELOCITY
	elif not is_on_floor(state):
		maximum_h_velocity = lerp(maximum_h_velocity, 0.0, 0.1)
		
	if input_h > 0:
		state.linear_velocity.x = clamp(state.linear_velocity.x, 0.0, maximum_h_velocity)
	elif input_h < 0:
		state.linear_velocity.x = clamp(state.linear_velocity.x, -maximum_h_velocity, 0.0)
	else :
		state.linear_velocity.x = clamp(state.linear_velocity.x, -maximum_h_velocity, maximum_h_velocity)
	
	emit_signal("_forces_integrated", state)

func can_jump(state: PhysicsDirectBodyState2D):
	return is_on_floor(state)

func is_on_floor(state: PhysicsDirectBodyState2D):
	var contact_count = state.get_contact_count()
	
	if state.get_contact_count() == 0: 
		return false
		
	for i in range(contact_count):
		var contact_normal = state.get_contact_local_normal(i)
		if contact_normal.dot(Vector2.UP) > 0.5:
			return true
	
	return false
	
func is_on_wall(state: PhysicsDirectBodyState2D):
	var contact_count = state.get_contact_count()
	
	if state.get_contact_count() == 0: 
		return false
		
	for i in range(contact_count):
		var contact_normal = state.get_contact_local_normal(i)
		if abs(contact_normal.dot(Vector2.LEFT)) > 0.5:
			return true
	
	return false
