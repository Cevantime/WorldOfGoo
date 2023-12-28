extends StateMachine

@export var VELOCITY = 100

@export var action_left = "move_left"
@export var action_right = "move_right"


var maximum_h_velocity = 0.0

# Called when the node enters the scene tree for the first time.
func _supports(node):
	return node is RigidBody2D

func _integrate_forces(state):
	var input_h = Input.get_axis(action_left, action_right)
	
	state.apply_central_impulse(Vector2.RIGHT * input_h * VELOCITY)
	
	
func _exit_state(_next):
	referer.physics_material_override.friction = 0
	referer.gravity_scale = 3

