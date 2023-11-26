extends Camera2D

var drag_cam = false
var old_mouse_pos
var follow_player = true

@export var CAMERA_SPEED: int = 2
@export var zoom_min = 1.0 # (float, 0.01, 10)
@export var zoom_max = 2.0 # (float, 0.02, 20)
@export var zoom_step = 0.2 # (float, 0.01, 10)
@export var zoom_speed = 5
@export var player_followed_path: NodePath
@export var initial_zoom: float = 1

@onready var zoom_target = zoom
@onready var player_followed = get_node(player_followed_path)

func _ready():
	set_zoom_value(initial_zoom)

func set_zoom_value(z):
	z = clamp(z, zoom_min, zoom_max)
	zoom_target = Vector2(z,z)
	
func _process(delta):
	zoom = lerp(zoom, zoom_target, delta * zoom_speed)
	if follow_player:
		global_position = lerp(global_position, player_followed.global_position, 0.5)
		global_position.y += -100.0 / zoom.x
	

func clamp_position(pos) :
	var viewport_radius = get_viewport_rect().size / 2 * zoom
	pos.x = clamp(pos.x, limit_left + viewport_radius.x, limit_right - viewport_radius.x)
	pos.y = clamp(pos.y, limit_top + viewport_radius.y, limit_bottom - viewport_radius.y)
	return pos
	
func _input(event):
	if event.is_action("zoom_in") or event.is_action("zoom_out"):
		var z = zoom_target.x
		
		if event.is_action("zoom_in") :
			z -= zoom_step
		if event.is_action("zoom_out") :
			z += zoom_step
			
		set_zoom_value(z)
		
	elif event is InputEventMouseMotion and Input.is_action_pressed("drag_cam") and not follow_player:
		position = clamp_position(position - (event.relative / zoom) * CAMERA_SPEED)
