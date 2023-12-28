extends "res://src/platforms/PathPlatform.gd"

@export var speed := 1.0
@export var pause_time := 4.0

@onready var path_follow_2d = $PathFollow2D

var current_speed := 0.0
	
func _ready():
	super()
	var tween = create_tween()
	tween.set_loops().set_ease(Tween.EASE_IN_OUT)
	var duration = curve.get_baked_length() / (speed * 80.0)
	tween.tween_property(path_follow_2d, "progress_ratio", 1.0, duration)
	tween.tween_property(path_follow_2d, "progress_ratio", 1.0, pause_time)
	tween.tween_property(path_follow_2d, "progress_ratio", 0.0, duration)
	tween.tween_property(path_follow_2d, "progress_ratio", 0.0, pause_time)
		
		



