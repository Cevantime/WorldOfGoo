extends Node2D

@onready var timer = $Timer

@export var timing := 1.0:
	set(v):
		timing = v
		timer.wait_time = v
		
		
@export var scene_to_spawn_packed: PackedScene
@export var spawning = false:
	set(v):
		if v :
			spawn()
			timer.start()
		else: 
			timer.stop()

signal scene_spawned(scene: Node)

func _ready():
	if spawning:
		timer.start()

func _on_timer_timeout():
	spawn()
	
	
func spawn():
	if not scene_to_spawn_packed:
		return
	var scene_to_spawn = scene_to_spawn_packed.instantiate()
	scene_to_spawn.global_transform = global_transform
	get_tree().current_scene.call_deferred("add_child", scene_to_spawn)
	emit_signal("scene_spawned", scene_to_spawn)
	
