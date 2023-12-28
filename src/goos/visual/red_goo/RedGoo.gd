extends "res://src/goos/visual/black_goo/BlackGoo.gd"

const PurpleGoo = preload("res://src/goos/visual/purple_goo/PurpleGoo.gd")

func _on_connect(other):
	super(other)
	var other_goo = other.referer.goo
	call_deferred("_check_connections")
	if other_goo is PurpleGoo:
		other_goo.connect("activated", Callable(self, "_on_activation"))
		other_goo.connect("deactivated", Callable(self, "_on_deactivation"))
		
		
func _on_activation():
	outline.show()
	_check_connections()

func _check_connections():
	_check_solid_connections()
	_check_red_connections()
	
func _check_solid_connections():
	# TODO: optimize by keeping ref to solid connections directly ?
	for sc in get_tree().get_nodes_in_group(Groups.SOLID_CONNECTIONS):
		var connectable_1 = sc.connectable_a
		var connectable_2 = sc.connectable_b
		if connectable_1 == connectable or connectable_2 == connectable:
			if should_be_active(connectable_1, connectable_2):
				sc.activate()
			else: 
				sc.deactivate()
			
func _check_red_connections():
	# TODO: optimize by keeping ref to red connections directly ?
	for rc in get_tree().get_nodes_in_group(Groups.RED_CONNECTIONS):
		var connectable_1 = rc.connectable_a
		var connectable_2 = rc.connectable_b
		if connectable_1 == connectable or connectable_2 == connectable:
			if should_be_active(connectable_1, connectable_2):
				rc.enable()
			else: 
				rc.disable()
		
func should_be_active(connectable_1, connectable_2):
	for c in [connectable_1, connectable_2]:
		var is_connected_to_purple = 0
		# TODO: optimize by keeping ref to neighbour connections directly ?
		for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
			var c_1 = pc.connectable_a
			var c_2 = pc.connectable_b
			if c_1 == c or c_2 == c:
				is_connected_to_purple = true
				break
		if not is_connected_to_purple:
			continue
		var active = false
		# TODO same here
		for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
			var c_1 = pc.connectable_a
			var c_2 = pc.connectable_b
			var g_1 = c_1.referer.get_parent()
			var g_2 = c_2.referer.get_parent()
			if (c_1 == c and g_2 is PurpleGoo and g_2.active) or (c_2 == c and g_1 is PurpleGoo and g_1.active):
				active = true
				break
		
		if not active:
			return false
		
	return true
		
func _on_deactivation():
	outline.hide()
	_check_connections()
