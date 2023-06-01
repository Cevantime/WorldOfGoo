extends StateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _supports(node):
	return node is CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Add the gravity.
	if not referer.is_on_floor():
		referer.velocity.y += gravity * 2 * delta
