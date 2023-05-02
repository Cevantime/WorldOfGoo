extends Line2D

@onready var target_width = width

var node_a_instance
var node_b_instance

func _ready():
	material = material.duplicate()
	appear()

func _process(_delta):
	if node_a_instance == null:
		return
		
	points[0] = node_a_instance.global_position
	points[1] = node_b_instance.global_position

func appear():
	width = 0
	var _t = create_tween().tween_property(self, "width", target_width, 0.8)

func set_color(color):
	(material as ShaderMaterial).set_shader_parameter("color", color)

func display():
	if ! visible:
		appear()
	show()
