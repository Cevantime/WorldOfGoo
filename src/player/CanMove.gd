extends StateMachine

func _supports(node):
	return node is CharacterBody2D


func _physics_process(_delta):
	referer.move_and_slide()
