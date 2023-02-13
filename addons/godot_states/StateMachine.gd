extends Node
class_name StateMachine, "res://addons/godot_states/state_opt.svg"

var referer: Node
var enabled: bool setget set_enabled

export(bool) var disabled setget set_disabled

func set_disabled(value):
	disabled = value
	if referer == null:
		return
	
	if self.enabled and disabled:
		self.enabled = false
		call_deferred("_exit_state", null, [] )
		
	elif !disabled and !enabled :
		if should_be_enabled_by_default():
			self.enabled = true
			call_deferred("_enter_state", null, [])
		
		else:
			self.enabled = false

func set_enabled(value):
	enabled = value
	set_process(enabled)
	set_physics_process(enabled)
	set_process_input(enabled)
	set_process_unhandled_input(enabled)
	if referer != null && referer.has_signal("_forces_integrated"):
		if enabled and not referer.is_connected("_forces_integrated", self, "_integrate_forces"):
			referer.connect("_forces_integrated", self, "_integrate_forces")
		elif referer.is_connected("_forces_integrated", self, "_integrate_forces"):
			referer.disconnect("_forces_integrated", self, "_integrate_forces")

		
func should_be_enabled_by_default():
	var parent: Node = get_parent()
	return (not(parent.has_method("change_state")) and _supports(parent) or (parent.has_method("_dummy_multiple_state_machine") and parent.enabled and _supports(referer)))
		
func _enter_tree():
	var parent = get_parent()
	enabled = should_be_enabled_by_default()
	if enabled:
		referer = parent
	elif parent.has_method("change_state"):
		referer = parent.referer
		

func _ready():
	set_enabled(enabled)
	if enabled:
		call_deferred("_enter_state", null, [])
		
func change_state(state_name: String, params: Array = []):
	var parent = get_parent()
	while parent != null and not "selected_state" in parent:
		parent = parent.get_parent()
	if parent != null:
		parent.change_state(state_name, params)

func get_referer_states_in_group(group_name: String):
	var referer_states = []
	for n in get_tree().get_nodes_in_group(group_name):
		if n.has_method("change_state") and n.referer == referer:
			referer_states.push_back(n)

	return referer_states
	
func disable_group(group_name: String, disabled: bool = true):
	for n in get_referer_states_in_group(group_name):
		n.disabled = disabled

func _supports(node: Node):
	return false
	
func _enter_state(previous, params = []):
	pass
	
func _exit_state(next):
	pass
	
func _integrate_forces(state):
	pass
