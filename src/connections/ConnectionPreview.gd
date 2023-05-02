extends "res://src/connections/ConnectionLine.gd"

func _ready():
	points[0] = node_a_instance.global_position
	points[1] = node_b_instance.global_position
	material = material.duplicate()

func display():
	show()
