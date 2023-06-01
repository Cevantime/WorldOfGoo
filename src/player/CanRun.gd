extends StateMachine

@export var SPEED = 150

func _supports(node):
	return node is CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		referer.velocity.x = direction * SPEED
	else:
		referer.velocity.x = move_toward(referer.velocity.x, 0, SPEED)
