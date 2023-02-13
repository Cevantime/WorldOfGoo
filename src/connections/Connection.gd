extends DampedSpringJoint2D

onready var node_a_instance = get_node(node_a)
onready var node_b_instance = get_node(node_b)

func _process(_delta):
	global_position = node_a_instance.global_position
	global_rotation = (node_a_instance.global_position - node_b_instance.global_position).angle() + PI / 2

	
