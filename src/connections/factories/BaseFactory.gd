@tool
extends Node

@export var connection_packed = preload("res://src/connections/Connection.tscn")
@export var joint_packed = preload("res://src/connections/ConnectionJoint.tscn")
@export var preview_line_packed = preload("res://src/connections/ConnectionPreview.tscn")
@export var line_packed = preload("res://src/connections/ConnectionLine.tscn")

func supports(_c1, _c2):
	return false
	
func _create_preview_line(c1, c2):
	var preview = preview_line_packed.instantiate()
	configure_connection_line(preview, c1, c2)
	return preview
	
func get_preview_line(c1, c2):
	return _create_preview_line(c1, c2)
	
	
func configure_connection_line(line, c1, c2):
	line.connectable_a = c1
	line.connectable_b = c2
	
func get_connection(c1, c2):
	return _create_connection(c1, c2)
	

func _create_connection(c1, c2):
	var connection = _create_default_joint(c1, c2)
	var line = _create_default_connection_line(c1, c2)
	return _wrap([connection, line], c1, c2)
	
func _create_default_connection_line(c1, c2):
	var line = line_packed.instantiate()
	configure_connection_line(line, c1, c2)
	return line

func _wrap(elements: Array, c1, c2):
	var node = connection_packed.instantiate()
	node.connectable_a = c1
	node.connectable_b = c2
	for e in elements:
		node.add_child(e)
	return node

func _create_default_joint(c1, c2):
	var joint = joint_packed.instantiate()
	var g1 = c1.referer
	var g2 = c2.referer
	joint.global_position = g1.global_position
	joint.global_rotation = (g1.global_position - g2.global_position).angle() + PI / 2
	joint.length = g1.global_position.distance_to(g2.global_position)
	joint.rest_length = joint.length
	joint.node_a = g1.get_path()
	joint.node_b = g2.get_path()
	return joint
