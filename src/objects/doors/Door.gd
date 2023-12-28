extends Node2D


@export var switch_path: NodePath
@export var opening_duration = 0.2

@onready var collision_shape_2d = $RigidBody2D/CollisionShape2D
@onready var rigid_body_2d = $RigidBody2D
@onready var switch = get_node(switch_path)
@onready var polygon_2d = $RigidBody2D/Polygon2D

var height
var original_height

func _ready():
	if not switch:
		return
	if not (switch.has_signal("activated") and switch.has_signal("deactivated")):
		printerr("door "+name+" needs to be connected to a switch !")
	switch.connect("activated", Callable(self, "_on_switch_activated"))
	switch.connect("deactivated", Callable(self, "_on_switch_deactivated"))
	
	var rect = collision_shape_2d.shape as RectangleShape2D
	height = rect.size.y
	
func _on_switch_activated():
	open()
	
func _on_switch_deactivated():
	close()
	
func open():
	var t = create_tween()
	t.tween_property(rigid_body_2d, "position", Vector2(0, -height / 2), opening_duration)
	t.parallel().tween_property(collision_shape_2d.shape, "size", Vector2(collision_shape_2d.shape.size.x, 0), opening_duration)
	t.parallel().tween_property(polygon_2d, "scale", Vector2(1, 0), opening_duration)
	
func close():
	var t = create_tween()
	t.tween_property(rigid_body_2d, "position", Vector2.ZERO, opening_duration)
	t.parallel().tween_property(collision_shape_2d.shape, "size", Vector2(collision_shape_2d.shape.size.x, height), opening_duration)
	t.parallel().tween_property(polygon_2d, "scale", Vector2.ONE, opening_duration)
