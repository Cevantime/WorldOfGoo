extends Polygon2D

@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D

func _ready():
	collision_polygon_2d.polygon = polygon

