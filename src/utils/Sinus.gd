extends Node

@export var amplitude: float = 1.0
@export var speed: float = 1.0

var time_acc_process = randi()
var time_acc_physics_process = randi()

var process_value = 0
var physics_process_value = 0

func _process(delta):
	increment_process(delta)
	
func _physics_process(delta):
	increment_physics_process(delta)
	
func get_value():
	return process_value
	
func get_process_value():
	return process_value
	
func get_physics_process_value():
	return physics_process_value
	
func increment_process(delta):
	time_acc_process = increment_value(time_acc_process, delta)
	process_value = sin(time_acc_process) * amplitude

func increment_physics_process(delta):
	time_acc_physics_process = increment_value(time_acc_physics_process, delta)
	physics_process_value = sin(time_acc_physics_process) * amplitude

func increment_value(initial_value, delta):
	var new_value = initial_value + delta * speed
	new_value = wrapf(new_value, 0, 2 * PI)
	return new_value
