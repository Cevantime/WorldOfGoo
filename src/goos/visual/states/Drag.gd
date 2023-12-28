extends SwitchableStateMachine

const Goo = preload("res://src/goos/visual/BaseGoo.gd")

@onready var body = referer.body

func _supports(node):
	return node is Goo
	
	
func _enter_state(previous, params = {}):
	super._enter_state(previous, params)


func _on_DeformedByMovement_contact_found():
	change_state("DeformedByCollision")


func _on_DeformedByCollision_contact_lost():
	change_state("DeformedByMovement")
