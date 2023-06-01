extends "res://src/managers/FocusOnManager.gd"

func _action(goo):
	goo.switch_to_just_connected()
	await goo.action_assigned
 
