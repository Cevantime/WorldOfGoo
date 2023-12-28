extends StateMachine

@export var VELOCITY = 100
@export var MAXIMUM_HORIZONTAL_VELOCITY = 200.0
@export var action_left = "move_left"
@export var action_right = "move_right"


var maximum_h_velocity = 0.0

# Called when the node enters the scene tree for the first time.
func _supports(node):
	return node is RigidBody2D

func _integrate_forces(state):
	var input_h = Input.get_axis(action_left, action_right)
	
	var wall = BodyUtils.get_wall(state)
	
	if wall == BodyUtils.WALL.NONE or sign(input_h) != wall:
		state.apply_central_impulse(Vector2.RIGHT * input_h * VELOCITY)
	
	if wall != BodyUtils.WALL.NONE or input_h != 0:
		referer.physics_material_override.friction = 0
	else:
		referer.physics_material_override.friction = 5
	
	if input_h != 0:
		maximum_h_velocity = MAXIMUM_HORIZONTAL_VELOCITY
			
	elif not BodyUtils.is_on_floor(state):
		maximum_h_velocity = lerp(maximum_h_velocity, 0.0, 0.1)
	
	if input_h > 0:
		state.linear_velocity.x = clamp(state.linear_velocity.x, 0.0, maximum_h_velocity)
	elif input_h < 0:
		state.linear_velocity.x = clamp(state.linear_velocity.x, -maximum_h_velocity, 0.0)
	else :
		state.linear_velocity.x = clamp(state.linear_velocity.x, -maximum_h_velocity, maximum_h_velocity)
	
	referer.gravity_scale = 3 if state.linear_velocity.y <= 0 else 5
	
func _exit_state(_next):
	referer.physics_material_override.friction = 0
	referer.gravity_scale = 3

