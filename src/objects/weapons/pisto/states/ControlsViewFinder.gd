extends StateMachine

const PistoConnector = preload("res://src/objects/weapons/pisto/PistoConnectorArea.gd")

var view_finder_area: Area2D
var pisto_speed = 0.0
var grabbed_area
var areas_inside_map = {}
var hovered_area
var is_mouse_entered = false
var levitation_ray

func _supports(node: Node):
	return node is PistoConnector
	
func move_view_finder(dir):
	view_finder_area.position += dir * referer.VIEW_FINDER_SPEED
	

func clamp_view_finder_position():
	var radius = referer.collision_shape_2d.shape.get_rect().size.x / 2.0 * referer.scale.x
	if view_finder_area.position.length_squared() > radius * radius:
		view_finder_area.position = view_finder_area.position.normalized() * radius
	
func grab_area(area):
	grabbed_area = area
	grabbed_area.pisto_grab(referer)
	levitation_ray.show()
	
func release_grabbed_area(do_action = true):
	levitation_ray.hide()
	if grabbed_area:
		grabbed_area.pisto_release(referer, do_action)
		grabbed_area = null
	
func _process(delta):
	if is_mouse_entered:
		view_finder_area.global_position = referer.get_global_mouse_position()
	else:
		var dir = Input.get_vector("pisto_left", "pisto_right", "pisto_up", "pisto_down")
		pisto_speed = lerp(pisto_speed, dir.length(), 0.1)
		move_view_finder(dir * delta * pisto_speed)
	
	clamp_view_finder_position()
	
	if Input.is_action_just_pressed("pisto_grab"):
		if hovered_area:
			grab_area(hovered_area)
	if Input.is_action_just_released("pisto_grab"):
		if grabbed_area:
			release_grabbed_area()
	
	if grabbed_area:
		levitation_ray.points[1] = grabbed_area.global_position - levitation_ray.global_position

func _enter_state(_previous, _params = {}):
	view_finder_area = referer.get_node("ViewFinderArea")
	if not view_finder_area.is_connected("area_entered", Callable(self, "_on_view_finder_area_area_entered")) :
		view_finder_area.connect("area_entered", Callable(self, "_on_view_finder_area_area_entered"))
		view_finder_area.connect("area_exited", Callable(self, "_on_view_finder_area_area_exited"))
	levitation_ray = referer.get_node("LevitationRay")

func _exit_state(_previous, _params = {}):
	if view_finder_area.is_connected("area_exited", Callable(self, "_on_view_finder_area_area_entered")):
		view_finder_area.disconnect("area_exited", Callable(self, "_on_view_finder_area_area_entered"))
		view_finder_area.disconnect("area_entered", Callable(self, "_on_view_finder_area_area_exited"))
		
	release_grabbed_area(false)


	
func _on_view_finder_area_area_entered(area):
	if not area.is_in_group(Groups.PISTO_GRABBABLE_AREAS):
		return
	if areas_inside_map.is_empty():
		hovered_area = area
		area.pisto_hover(referer)
		
	areas_inside_map[area.get_instance_id()] = area


func _on_view_finder_area_area_exited(area):
	areas_inside_map.erase(area.get_instance_id())
	
	if area == hovered_area:
		area.pisto_exit(referer)
	
	if areas_inside_map.is_empty():
		hovered_area = null
	else:
		hovered_area = areas_inside_map.values()[0]
		area.pisto_hover(referer)


func _on_pisto_connector_area_mouse_entered():
	is_mouse_entered = true


func _on_pisto_connector_area_mouse_exited():
	is_mouse_entered = false
	if view_finder_area != null:
		view_finder_area.position = Vector2.ZERO
		release_grabbed_area(false)
