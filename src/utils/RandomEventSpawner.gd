extends Node

@onready var timer = $Timer

@export var MAXIMUM_FREQUENCY: float = 3.0
@export var MINIMUM_FREQUENCY: float = 7.0

signal event_generated


func compute_next_wait_time() -> float:
	return randf_range(MINIMUM_FREQUENCY, MAXIMUM_FREQUENCY)


func stop():
	timer.stop()
	
func start():
	restart()

func restart():
	timer.start(compute_next_wait_time())
	
	
func _on_Timer_timeout():
	emit_signal("event_generated")
	restart()
