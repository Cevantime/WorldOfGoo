extends "res://src/goos/visual/black_goo/BlackGoo.gd"

@onready var connectable = $GooBody/Connectable

const PurpleGoo = preload("res://src/goos/visual/purple_goo/PurpleGoo.gd")

func _on_connectable_connected(other):
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
		var goo1 = sc.connectable_a
		var goo2 = sc.connectable_b
		if goo1 == connectable or goo2 == connectable:
			if should_be_active(goo1, goo2):
				sc.activate()
			else: 
				sc.deactivate()
			
func _check_red_connections():
	# TODO: optimize by keeping ref to red connections directly ?
	for rc in get_tree().get_nodes_in_group(Groups.RED_CONNECTIONS):
		var goo1 = rc.connectable_a
		var goo2 = rc.connectable_b
		if goo1 == connectable or goo2 == connectable:
			if should_be_active(goo1, goo2):
				rc.enable()
			else: 
				rc.disable()
		
func should_be_active(goo1, goo2):
	for g in [goo1, goo2]:
		var is_connected_to_purple = 0
		# TODO: optimize by keeping ref to neighbour connections directly ?
		for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
			var g1 = pc.connectable_a
			var g2 = pc.connectable_b
			if g1 == g or g2 == g:
				is_connected_to_purple = true
				break
		if not is_connected_to_purple:
			continue
		var active = false
		# TODO same here
		for pc in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
			var g1 = pc.connectable_a
			var g2 = pc.connectable_b
			if (g1 == g and g2 is PurpleGoo and g2.active) or (g2 == g and g1 is PurpleGoo and g1.active):
				active = true
				break
		
		if not active:
			return false
		
	return true
		
func _on_deactivation():
	outline.hide()
	_check_connections()
