extends Node

var sinus_packed = preload("res://src/utils/Sinus.tscn")

func create_sinus(o, amplitude, speed, processed = true, physics_processed = false):
	var sinus = sinus_packed.instantiate()
	sinus.set_process(processed)
	sinus.set_physics_process(physics_processed)
	sinus.amplitude = amplitude
	sinus.speed = speed
	o.call_deferred("add_child", sinus)
	return sinus
	
func get_child_in_group(node, group):
	for c in node.get_children():
		if c.is_in_group(group):
			return c
			
	return null
