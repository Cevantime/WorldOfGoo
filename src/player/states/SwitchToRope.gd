extends StateMachine

const PlayerRigid = preload("res://src/player/rigid/PlayerRigid.gd")

var rope


func _supports(node):
	return node is PlayerRigid
	
func _enter_state(_previous, params = {}):
	rope = params.target


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		change_state("Default")
	if rope.global_position.distance_to(referer.global_position) < 0.3:
		change_state("OnRope", {"target" : rope})
	
