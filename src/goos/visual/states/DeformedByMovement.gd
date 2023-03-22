extends StateMachine

signal contact_found

const Goo = preload("res://src/goos/visual/BaseGoo.gd")

@onready var sinus = Utils.create_sinus(0.08, 10)

func _supports(node):
	return node is Goo
	
func _enter_state(_previous, _params = []):
	referer.deformation_vertical_influence = 1.0
	
func _process(_delta):
	var body = referer.body
	if body.contact_count > 0:
		emit_signal("contact_found")
		return
		
	var linear_velocity = referer.body.linear_velocity
	var linear_velocity_length = linear_velocity.length()
	referer.deformation = min(referer.DEFORMATION_FACTOR * linear_velocity_length * 0.001, referer.DEFORMATION_AMPLITUDE) * linear_velocity.normalized()
	
	
