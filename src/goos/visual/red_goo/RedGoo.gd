extends "res://src/goos/visual/black_goo/BlackGoo.gd"

const PurpleGoo = preload("res://src/goos/visual/purple_goo/PurpleGoo.gd")

func _on_connectable_connected(other):
	var parent = other.referer.get_parent()
	call_deferred("_check_connections")
	if parent is PurpleGoo:
		parent.connect("activated", Callable(self, "_on_activation"))
		parent.connect("deactivated", Callable(self, "_on_deactivation"))
		
		
func _on_activation():
	outline.show()
	_check_connections()

func _check_connections():
	_check_solid_connections()
	_check_red_connections()
	
func _check_solid_connections():
	for sc in get_tree().get_nodes_in_group(Groups.SOLID_CONNECTIONS):
		var goo1 = sc.node_a_instance.get_parent()
		var goo2 = sc.node_b_instance.get_parent()
		if goo1 == self or goo2 == self:
			if should_be_active(goo1, goo2):
				sc.activate()
			else: 
				sc.deactivate()
			
func _check_red_connections():
	for rc in get_tree().get_nodes_in_group(Groups.RED_CONNECTIONS):
		var goo1 = rc.node_a_instance.get_parent().get_parent()
		var goo2 = rc.node_b_instance.get_parent().get_parent()
		if goo1 == self or goo2 == self:
			if should_be_active(goo1, goo2):
				rc.enable()
			else: 
				rc.disable()
		
func should_be_active(goo1, goo2):
	for g in [goo1, goo2]:
		var is_connected_to_purple = 0
		for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
			var g1 = pc.node_a_instance.get_parent().get_parent()
			var g2 = pc.node_b_instance.get_parent().get_parent()
			if g1 == g or g2 == g:
				is_connected_to_purple = true
				break
		if not is_connected_to_purple:
			continue
		var active = false
		for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
			var g1 = pc.node_a_instance.get_parent().get_parent()
			var g2 = pc.node_b_instance.get_parent().get_parent()
			if (g1 == g and g2 is PurpleGoo and g2.active) or (g2 == g and g1 is PurpleGoo and g1.active):
				active = true
				break
		
		if not active:
			return false
		
	return true
		
func _on_deactivation():
	outline.hide()
	_check_connections()
