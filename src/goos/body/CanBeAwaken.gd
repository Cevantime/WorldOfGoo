extends StateMachine

signal is_awaken

var awake_area: Area2D

func _supports(_node):
	return referer.has_node("AwakeArea")

func _enter_state(_previous, _params = []):
	awake_area = referer.get_node("AwakeArea")
	if not awake_area.is_connected("body_entered", Callable(self, "_on_awake_area_body_entered")):
		awake_area.connect("body_entered", Callable(self, "_on_awake_area_body_entered"))

func _exit_state(_next):
	awake_area.disconnect("body_entered", Callable(self, "_on_awake_area_body_entered"))

func _on_awake_area_body_entered(body):
	if body.is_in_group(Groups.PLAYERS):
		emit_signal("is_awaken")
		change_state("Idle")
