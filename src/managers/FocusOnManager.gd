extends StateMachine

var camera
var focusable_stack = []


func _supports(node):
	return node.is_in_group(Groups.LEVELS)


func _enter_state(_previous, _params = {}):
	camera = referer.main_camera
	for focusable in get_tree().get_nodes_in_group(Groups.FOCUSABLES):
		focusable.connect("focus_requested", Callable(self, "_on_focus_requested"))

func _exit_state(_previous, _params = {}):
	for focusable in get_tree().get_nodes_in_group(Groups.FOCUSABLES):
		focusable.disconnect("focus_requested", Callable(self, "_on_focus_requested"))
	
func _process(_delta):
	if focusable_stack.size() == 0:
		return
		
	set_process(false)
	
	var old_cam_zoom = camera.zoom_target
	var old_cam_pos = camera.global_position
	
	for focusable in focusable_stack:
		var focusable_ref = focusable.referer
		camera.follow_player = false
		focusable_ref.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		var tw = create_tween().tween_property(camera, "global_position", focusable.target.global_position, 0.2)
		await tw.finished
		camera.zoom_target = Vector2(2,2)
		await focusable.focus_released
		get_tree().paused = false
		focusable_ref.process_mode = ProcessMode.PROCESS_MODE_INHERIT
		
	camera.follow_player = true
	
	focusable_stack = []
	
	camera.zoom_target = old_cam_zoom
	create_tween().tween_property(camera, "global_position", old_cam_pos, 0.2)
	
	set_process(true)
	
func _on_focus_requested(focusable):
	focusable_stack.push_back(focusable)
	
	
	



