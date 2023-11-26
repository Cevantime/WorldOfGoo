extends RigidBody2D

@export_flags_2d_physics var enabled_layer
@export_flags_2d_physics var disabled_layer

@export_flags_2d_physics var enabled_mask
@export_flags_2d_physics var disabled_mask

@onready var shape: RectangleShape2D = $CollisionShape2D.shape as RectangleShape2D

var node_a_instance
var node_b_instance

@export var length: float = 50:
	set(value):
		if shape: shape.size = Vector2(value, 5)
		length = value


func deactivate():
	collision_layer = disabled_layer
	collision_mask = disabled_mask
	
func activate():
	collision_layer = enabled_layer
	collision_mask = enabled_mask
