extends StateMachine

signal contact_lost

const Goo = preload("res://src/goos/visual/BaseGoo.gd")
var deformation = Vector2.ZERO

@onready var sinus = Utils.create_sinus(self, referer.DEFORMATION_AMPLITUDE * 0.4, referer.BOUNCING_SPEED)

func _supports(node):
	return node is Goo

func _enter_state(_previous, _params = {}):
	referer.deformation_vertical_influence = 0.5
	
func _process(_delta):
	var body = referer.body
	if body.contact_count == 0:
		emit_signal("contact_lost")
		return
		
	var deformation_factor = sinus.get_value()
	deformation = referer.body.contact_normal.rotated(-PI/2).normalized() * deformation_factor
	referer.deformation = deformation
	
