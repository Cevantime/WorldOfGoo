extends Node

@export var amplitude: float = 1.0
@export var speed: float = 1.0

var time_acc_process = randi()
var time_acc_physics_process = randi()
var value = 0

func _process(delta):
	increment_process(delta)
	
func _physics_process(delta):
	increment_physics_process(delta)
	
func get_value():
	return value
	
func increment_process(delta):
	time_acc_process += delta * speed
	time_acc_process = wrapf(time_acc_process, 0, 2 * PI)
	value = sin(time_acc_process) * amplitude

func increment_physics_process(delta):
	time_acc_physics_process += delta * speed
	time_acc_physics_process = wrapf(time_acc_physics_process, 0, 2 * PI)
	value = sin(time_acc_physics_process) * amplitude
