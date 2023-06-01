extends StateMachine

@export var JUMP_VELOCITY = 200.0

func _supports(node):
	return node is CharacterBody2D
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept") and referer.is_on_floor():
		referer.velocity.y = -JUMP_VELOCITY
