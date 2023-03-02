extends StateMachine

var Goo = preload("res://src/goos/visual/BaseGoo.gd")
var referer_connectable

onready var connection_renderer = $ConnectionsRenderer

func _supports(node):
	return node is Goo and get_connectable(node.body)
	
func _enter_state(_previous, _params = []):
	referer_connectable = get_connectable(referer.body)
	
func get_connectable(node):
	return ConnectionManager.get_connectable(node)
	
func _exit_state(_next):
	connection_renderer.hide_connections()
	
func _process(_delta):
	var connectables = get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE)
	
	var linkables = []
	
	for connectable in connectables:
		if ConnectionManager.check_connectables_are_linkable(connectable, referer_connectable):
			linkables.push_back(connectable)
	
	connection_renderer.hide_connections()
	
	if linkables.size() < 2:
		return
	
	for i in range(0, linkables.size()):
		var connection = connection_renderer.get_connection(i)
		var goo = linkables[i].referer
		connection_renderer.show_connection(connection, referer.sprite_rotation, goo)
