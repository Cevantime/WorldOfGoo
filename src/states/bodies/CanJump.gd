extends StateMachine

@export var JUMP_FORCE = 100
@export var jump_action = "jump"
@export var MAX_VERTICAL_SPEED = 290

@onready var jump_timer = $JumpTimer

signal jump_started()

var do_jump = false

func _supports(node):
	return node is RigidBody2D


func _integrate_forces(state:PhysicsDirectBodyState2D):
	state.linear_velocity.y = max(-MAX_VERTICAL_SPEED, state.linear_velocity.y)
	
	if Input.is_action_pressed(jump_action) and can_jump(state):
		state.apply_central_impulse(Vector2.UP * JUMP_FORCE)
		do_jump = false
		if jump_timer.is_stopped():
			jump_timer.start()
			emit_signal("jump_started")


func can_jump(state: PhysicsDirectBodyState2D):
	return (_check_jump(state) and jump_timer.is_stopped()) or do_jump

func _check_jump(state):
	return BodyUtils.is_on_floor(state)
	
func _on_advanced_timer_iteration_done(_iteration_index):
	do_jump = true


func _on_advanced_timer_finished():
	do_jump = false
