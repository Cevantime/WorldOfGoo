extends StateMachine

const PurpleGoo = preload("res://src/goos/visual/purple_goo/PurpleGoo.gd")

var connectable
var outline
var lines = []

@onready var timer = $Timer

func _supports(node: Node):
	return node is PurpleGoo
	
func _process(_delta):
	if Input.is_action_just_pressed(referer.action_name):
		outline.show()
		timer.start()
		for line in lines:
			line.send_signal()
	elif Input.is_action_just_released(referer.action_name):
		if not timer.is_stopped(): 
			timer.stop()
		for line in lines:
			line.reset()
		outline.hide()
		referer.active = false
		referer.emit_signal("deactivated")
		
func _enter_state(_previous, _params = {}):
	connectable = ConnectionManager.get_connectable(referer.body)
	connectable.connect("connected", Callable(self, "_on_connected"))
	outline = referer.outline
	refresh_animation_players()
	

func _on_connected(_other):
	call_deferred("refresh_animation_players")
	
func refresh_animation_players():
	lines = []
	var referer_connectable = referer.connectable
	# TODO: optimize !
	for c in get_tree().get_nodes_in_group(Groups.PURPLE_CONNECTIONS):
		if c.connectable_a == referer_connectable or c.connectable_b == referer_connectable:
			lines.push_back(c)
	

func _on_timer_timeout():
	referer.active = true
	referer.emit_signal("activated")
