@tool
extends Node2D

@onready var canon_polygon_2d = $CanonRigidBody2D/CanonPolygon2D
@onready var ray_cast_2d = $CanonRigidBody2D/RayCast2D
@onready var canon_collision_polygon_2d = $CanonRigidBody2D/CanonCollisionPolygon2D
@onready var base_collision_polygon_2d = $BaseStaticBody2D/BaseCollisionPolygon2D
@onready var base_polygon_2d = $BaseStaticBody2D/BasePolygon2D
@onready var timer = $Timer
@onready var spawner = $CanonRigidBody2D/Spawner
@onready var canon_rigid_body_2d = $CanonRigidBody2D

@export var bullet_packed_scene: PackedScene
@export var spawn_timing: float = 1.0

@export_range(0, 500) var range = 200:
	set(v):
		if not is_node_ready():
			await ready
		range = v
		ray_cast_2d.target_position.y = range
		
@export_range(-45, 45, 1) var angle: int = 0:
	set(v):
		if not is_node_ready():
			await ready
		angle = v
		canon_rigid_body_2d.rotation_degrees = angle

func _ready():
	if not Engine.is_editor_hint():
		timer.wait_time = spawn_timing
		timer.start()
		canon_collision_polygon_2d.polygon = canon_polygon_2d.polygon
		base_collision_polygon_2d.polygon = base_polygon_2d.polygon
		ray_cast_2d.queue_free()


func _on_timer_timeout():
	var bullet = bullet_packed_scene.instantiate()
	bullet.velocity = spawner.global_transform.x
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = spawner.global_position

