extends Path2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$PathFollow2D/RigidBody2D/CollisionPolygon2D.polygon = $PathFollow2D/RigidBody2D/Polygon2D.polygon

