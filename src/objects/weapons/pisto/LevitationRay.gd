@tool
extends Line2D

@export var deformation_scale = 25.0;

@onready var shader_material: ShaderMaterial = material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var length = get_length()
	shader_material.set_shader_parameter("noise_scale", length / deformation_scale)
	shader_material.set_shader_parameter("deformation", length /deformation_scale)
	
	
func get_length():
	var length = 0
	var point_count = get_point_count()
	if point_count == 0:
		return length
	var i = 1
	var point_pos = get_point_position(0)
	while i < get_point_count():
		var next_point = get_point_position(i)
		length += point_pos.distance_to(next_point)
		i += 1
	return length
