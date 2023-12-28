extends Timer

signal iteration_done(iteration_index: int)
signal finished

@export var iterations_count = 1

var current_iteration = 0

func _on_timeout():
	emit_signal("iteration_done", current_iteration)
	current_iteration += 1
	if current_iteration >= iterations_count:
		emit_signal("finished")
		stop()
	
func reset(w_time: float = -1):
	current_iteration = 0
	if w_time > 0:
		wait_time = w_time

@warning_ignore("native_method_override")
func start(w_time: float = -1):
	one_shot = false
	reset()
	super(w_time)
	
func restart(w_time: float = -1):
	stop()
	self.start(w_time)
