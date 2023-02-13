tool
extends EditorPlugin

func _enter_tree():
	var scriptState = preload("StateMachine.gd")
	var textureState = preload("state_opt.svg")
	var scriptSwitchableState = preload("SwitchableStateMachine.gd")
	var textureSwitchableState = preload("switchablestate_opt.svg")
	var scriptMultipleState = preload("MultipleStateMachine.gd")
	var textureMultipleState = preload("multistate_opt.svg")
	var scriptStateRigidBody = preload("res://addons/godot_states/StateRigidBody2D.gd")
	add_custom_type("StateMachine", "Node", scriptState, textureState)
	add_custom_type("SwitchableStateMachine", "Node", scriptSwitchableState, textureSwitchableState)
	add_custom_type("MultipleStateMachine", "Node", scriptMultipleState, textureMultipleState)
	add_custom_type("StateRigidBody2D", "RigidBody2D", scriptStateRigidBody, null)

func _exit_tree():
	remove_custom_type("StateMachine")
	remove_custom_type("SwitchableStateMachine")
	remove_custom_type("MultipleStateMachine")
	remove_custom_type("StateRigidBody2D")
