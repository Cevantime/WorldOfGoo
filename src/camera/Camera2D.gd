extends Camera2D

var drag_cam = false
var old_mouse_pos

@export var CAMERA_SPEED: int = 2
@export var zoom_min = 1.0 # (float, 0.01, 10)
@export var zoom_max = 2.0 # (float, 0.02, 20)
@export var zoom_speed = 0.2 # (float, 0.01, 10)

@onready var zoom_target = zoom

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(_delta):
	zoom = lerp(zoom, zoom_target, 0.1)
	

func clamp_position(pos) :
	var viewport_radius = get_viewport_rect().size / 2 * zoom
	pos.x = clamp(pos.x, limit_left + viewport_radius.x, limit_right - viewport_radius.x)
	pos.y = clamp(pos.y, limit_top + viewport_radius.y, limit_bottom - viewport_radius.y)
	return pos
	
func _input(event):
	if event.is_action("zoom_in") or event.is_action("zoom_out"):
		var z = zoom_target.x
		
		if event.is_action("zoom_in") :
			z -= zoom_speed
		if event.is_action("zoom_out") :
			z += zoom_speed
			
		z = clamp(z, zoom_min, zoom_max)
		
		zoom_target = Vector2(z,z)
		
	elif event is InputEventMouseMotion and Input.is_action_pressed("drag_cam"):
		position = clamp_position(position - event.relative * zoom * CAMERA_SPEED)
