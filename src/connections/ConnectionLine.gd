@tool
extends Line2D

@onready var target_width = width
@onready var animation_player = $AnimationPlayer

var node_a_instance
var node_b_instance

var connectable_a: 
	set(v):
		connectable_a = v
		node_a_instance = v.visual
		
var connectable_b:
	set(v):
		connectable_b = v
		node_b_instance = v.visual

@export var connectable_a_path: NodePath
@export var connectable_b_path: NodePath

	
var backwards = false:
	set(value):
		backwards = value
		var shader_material = material as ShaderMaterial
		shader_material.set_shader_parameter("backwards", value)
		set_default_signal_ratio()

signal signal_sent

func _ready():
	if connectable_a_path:
		connectable_a = get_node(connectable_a_path)
		connectable_b = get_node(connectable_b_path)
		
	material = material.duplicate()
	appear()

func _process(_delta):
	if node_a_instance == null:
		return
		
	points[0] = node_a_instance.global_position
	points[1] = node_b_instance.global_position

func appear():
	width = 0
	create_tween().tween_property(self, "width", target_width, 0.8)

func set_color(color):
	(material as ShaderMaterial).set_shader_parameter("color", color)

func disable():
	change_alpha(0.4)
	(material as ShaderMaterial).set_shader_parameter("display_tex", false)
	
func enable():
	change_alpha(1)
	(material as ShaderMaterial).set_shader_parameter("display_tex", true)
	
	
func change_alpha(alpha):
	var shader_material = material as ShaderMaterial
	var color = shader_material.get_shader_parameter("color")
	color.a = alpha
	shader_material.set_shader_parameter("color", color)
	
func display():
	if ! visible:
		appear()
	show()
	
func send_signal():
	if backwards:
		animation_player.play_backwards("send_signal")
	else:
		animation_player.play("send_signal")
	await animation_player.animation_finished
	emit_signal("signal_sent")
	
func default_signal_ratio():
	return 1.3 if backwards else -1.3
	
func set_default_signal_ratio():
	var shader_material = material as ShaderMaterial
	shader_material.set_shader_parameter("signal_ratio", default_signal_ratio())
	
func reset():
	animation_player.stop()
	set_default_signal_ratio()
	

