extends SwitchableStateMachine

var Goo = preload("res://src/goos/visual/BaseGoo.gd")

onready var body = referer.body

func _supports(node):
	return node is Goo
	
	
func _enter_state(previous, params = []):
	._enter_state(previous, params)


func _on_Free_contact_found():
	change_state("Colliding")
