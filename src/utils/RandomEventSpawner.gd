extends Node

onready var timer = $Timer

export(float) var MAXIMUM_FREQUENCY = 3.0
export(float) var MINIMUM_FREQUENCY = 7.0

signal event_generated


func compute_next_wait_time() -> float:
	return rand_range(MINIMUM_FREQUENCY, MAXIMUM_FREQUENCY)


func stop():
	timer.stop()
	
func start():
	restart()

func restart():
	timer.start(compute_next_wait_time())
	
	
func _on_Timer_timeout():
	emit_signal("event_generated")
	restart()
