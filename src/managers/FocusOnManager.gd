extends StateMachine

var camera
var connected_goos_stack = []

@export var group_name: String
@export var signal_name: String

func _supports(node):
	return node.is_in_group(Groups.LEVELS)

func _ready():
	for goo in get_tree().get_nodes_in_group(group_name):
		goo.connect(signal_name, Callable(self, "_on_signal"))
		
func _enter_state(_previous, _params = []):
	camera = referer.get_node("Camera2D")

func _process(_delta):
	if connected_goos_stack.size() == 0:
		return
		
	set_process(false)
	
	var old_cam_zoom = camera.zoom_target
	var old_cam_pos = camera.global_position
	camera.zoom_target = Vector2(2,2)
	
	for goo in connected_goos_stack:
		goo.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		create_tween().tween_property(camera, "global_position", goo.body.global_position, 0.2)
		await _action(goo)
		get_tree().paused = false
		goo.process_mode = ProcessMode.PROCESS_MODE_INHERIT
		
	connected_goos_stack = []
	
	camera.zoom_target = old_cam_zoom
	create_tween().tween_property(camera, "global_position", old_cam_pos, 0.2)
	
	set_process(true)
	
func _on_signal(goo):
	connected_goos_stack.push_back(goo)
	

func _action(_goo):
	pass
	
	



