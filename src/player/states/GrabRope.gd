extends StateMachine


const PlayerRigid = preload("res://src/player/rigid/PlayerRigid.gd")

var joint

func _supports(node):
	return node is PlayerRigid
	
func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		change_state("Default")
		
func _enter_state(_previous, params = {}):
	var rope = params.target
	joint = PinJoint2D.new()
	joint.node_a = referer.get_path()
	joint.node_b = rope.get_path()
	joint.position = referer.global_position
	get_tree().current_scene.call_deferred("add_child", joint)
	
func _exit_state(_next):
	if referer.is_connected("rope_visited", Callable(self, "_on_rope_visited")):
		referer.disconnect("rope_visited", Callable(self, "_on_rope_visited"))
	joint.call_deferred("queue_free")

func _on_can_jump_jump_started():
	change_state("Default")
