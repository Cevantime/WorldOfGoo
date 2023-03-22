extends Polygon2D

@onready var collision_polygon = $StaticBody2D/CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_polygon.polygon = polygon


