extends Node

@export var connection_preview_packed: PackedScene = preload("res://src/connections/ConnectionPreview.tscn")
var connections_preview_pool = []

func show_connection(connection, n1, n2):
	connection.points[0] = n1.global_position
	connection.points[1] = n2.global_position
	connection.show()
	
func hide_connections():
	for connection in connections_preview_pool:
		connection.hide()
		
func get_connection(index):
	if index >= connections_preview_pool.size():
		for _i in range(connections_preview_pool.size(), index + 1) :
			connections_preview_pool.push_back(instantiate_connection())
	return connections_preview_pool[index]

func instantiate_connection():
	var connection = connection_preview_packed.instantiate()
	get_tree().get_root().add_child(connection)
	return connection
