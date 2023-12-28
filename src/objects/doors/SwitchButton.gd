extends Node2D

signal activated
signal deactivated

@export var permanent = false

@onready var button = $Button
@onready var damped_spring_joint_2d = $DampedSpringJoint2D


func _on_area_2d_body_entered(body):
	if body == button:
		if permanent:
			damped_spring_joint_2d.queue_free()
		emit_signal("activated")


func _on_area_2d_body_exited(body):
	if body == button :
		emit_signal("deactivated")
