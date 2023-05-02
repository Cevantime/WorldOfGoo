extends RigidBody2D

@onready var shape: RectangleShape2D = $CollisionShape2D.shape as RectangleShape2D

@export var length: float = 50:
	set(value):
		if shape: shape.size = Vector2(value, 5)
		length = value

