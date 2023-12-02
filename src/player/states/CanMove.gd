extends StateMachine

@export var JUMP_FORCE = 100
@export var VELOCITY = 100
@export var MAXIMUM_HORIZONTAL_VELOCITY = 200.0

enum WALL {
	NONE = 0, LEFT = -1, RIGHT = 1
}

var maximum_h_velocity = 0.0

# Called when the node enters the scene tree for the first time.
func _supports(node):
	return node is RigidBody2D

func _integrate_forces(state):
	if Input.is_action_just_pressed("jump") and can_jump(state):
		state.apply_central_impulse(Vector2.UP * JUMP_FORCE)
		
	var input_h = Input.get_axis("move_left", "move_right")
	
	var wall = get_wall(state)
	
	if wall == WALL.NONE or sign(input_h) != wall:
		state.apply_central_impulse(Vector2.RIGHT * input_h * VELOCITY)
	
	
	if wall != WALL.NONE or input_h != 0:
		referer.physics_material_override.friction = 0
	else:
		referer.physics_material_override.friction = 5
	
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
	return get_wall(state) != WALL.NONE
	
func get_wall(state: PhysicsDirectBodyState2D):
	var contact_count = state.get_contact_count()
	
	if contact_count == 0: 
		return WALL.NONE
		
	for i in range(contact_count):
		var contact_normal = state.get_contact_local_normal(i)
		if abs(contact_normal.dot(Vector2.LEFT)) > 0.5:
			var contact_position = state.get_contact_local_position(i)
			return WALL.LEFT if contact_position.x < referer.global_position.x else WALL.RIGHT
	
	return WALL.NONE
