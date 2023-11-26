extends Polygon2D

signal player_won
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionPolygon2D.polygon = polygon


func _on_area_2d_body_entered(_body):
	emit_signal("player_won")
