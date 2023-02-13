extends Node

var sinus_packed = preload("res://src/utils/Sinus.tscn")

func create_sinus(amplitude, speed, processed = true, physics_processed = false):
	var sinus = sinus_packed.instance()
	sinus.set_process(processed)
	sinus.set_physics_process(physics_processed)
	sinus.amplitude = amplitude
	sinus.speed = speed
	get_tree().get_root().call_deferred("add_child", sinus)
	return sinus
	
