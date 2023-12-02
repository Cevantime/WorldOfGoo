extends StateMachine

const PlayerRigid = preload("res://src/player/rigid/PlayerRigid.gd")

var pisto

func _supports(node):
	return node is PlayerRigid
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("use_pisto"):
		change_state("Default")
