extends Node2D

@onready var timer = $Timer

@export var timing := 1.0:
	set(v):
		timing = v
		timer.wait_time = v
		
		
@export var scene_to_spawn_packed: PackedScene

signal scene_spawned(scene: Node)

func _on_timer_timeout():
	var scene_to_spawn = scene_to_spawn_packed.instantiate()
	scene_to_spawn.global_position = global_position
	get_tree().current_scene.add_child(scene_to_spawn)
	emit_signal("scene_spawned", scene_to_spawn)
	
