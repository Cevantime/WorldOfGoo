@tool
extends "res://src/connections/factories/BaseFactory.gd"

@export var packed_solid_connection = preload("res://src/connections/SolidConnection.tscn")

func supports(c1, c2):
	var ref1 = c1.referer.get_parent()
	var ref2 = c2.referer.get_parent()
	return ref1.is_in_group(Groups.RED_GOOS) and ref2.is_in_group(Groups.RED_GOOS)
	
func _create_connection(c1, c2):
	var connection = super._create_connection(c1, c2)
	var ref1 = c1.referer
	var ref2 = c2.referer
	var p1 = ref1.global_position
	var p2 = ref2.global_position
	
	var solid_connection = packed_solid_connection.instantiate()
	solid_connection.global_rotation = p2.angle_to_point(p1)
	solid_connection.global_position = p1.lerp(p2, 0.5)
	solid_connection.node_a_instance = ref1
	solid_connection.node_b_instance = ref2
	solid_connection.connectable_a = c1
	solid_connection.connectable_b = c2
	connection.add_child(solid_connection)
	call_deferred("add_pins", connection, ref1, ref2, solid_connection)
	return connection

func add_pins(connection,ref1, ref2, solid_connection):
	var p1 = ref1.global_position
	var p2 = ref2.global_position
	var dist = p1.distance_to(p2)
	solid_connection.length = dist
	var pin1 = PinJoint2D.new()
	pin1.node_a = ref1.get_path()
	pin1.node_b = solid_connection.get_path()
	pin1.global_position = p1
	var pin2 = PinJoint2D.new()
	pin2.node_a = ref2.get_path()
	pin2.node_b = solid_connection.get_path()
	pin2.global_position = p2
	connection.add_child(pin1)
	connection.add_child(pin2)
