extends Node

var time_acc = randi()
var amplitude
var speed
var value = 0

func _process(delta):
	increment(delta)
	
func get_value():
	return value
	
func increment(delta):
	time_acc += delta * speed
	time_acc = wrapf(time_acc, 0, 2 * PI)
	value = sin(time_acc) * amplitude
