extends StateMachine

var Goo = preload("res://src/goos/Goo.gd")

onready var connection_renderer = $ConnectionsRenderer

func _supports(node):
	return node is Goo
	
	
func _exit_state(_next):
	connection_renderer.hide_connections()
	
func _process(_delta):
	var connected_goos = get_tree().get_nodes_in_group("goo")
	
	var connectable_goos = []
	
	for goo in connected_goos:
		if ConnectionManager.check_goos_are_linkable(goo, referer.body):
			connectable_goos.push_back(goo)
	
	connection_renderer.hide_connections()
	
	if connectable_goos.size() < 2:
		return
	
	for i in range(0, connectable_goos.size()):
		var connection = connection_renderer.get_connection(i)
		var goo = connectable_goos[i]
		connection_renderer.show_connection(connection, referer.sprite_rotation, goo)
