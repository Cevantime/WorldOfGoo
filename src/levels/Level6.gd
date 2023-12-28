extends "res://src/levels/BaseLevel.gd"

@onready var spawner = $Objects/Canon/CanonRigidBody2D/Spawner

func _on_switch_button_activated():
	spawner.spawning = true


func _on_switch_button_deactivated():
	spawner.spawning = false
