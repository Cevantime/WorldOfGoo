@tool
extends Node2D

@onready var canon_polygon_2d = $CanonRigidBody2D/CanonPolygon2D
@onready var ray_cast_2d = $CanonRigidBody2D/RayCast2D
@onready var canon_collision_polygon_2d = $CanonRigidBody2D/CanonCollisionPolygon2D
@onready var base_collision_polygon_2d = $BaseStaticBody2D/BaseCollisionPolygon2D
@onready var base_polygon_2d = $BaseStaticBody2D/BasePolygon2D
@onready var canon_rigid_body_2d = $CanonRigidBody2D
@onready var spawner = $CanonRigidBody2D/Spawner
@export var bullet_packed_scene: PackedScene:
	set(v):
		bullet_packed_scene = v
		if not is_node_ready():
			await ready
		spawner.scene_to_spawn_packed = v
		
@export var spawn_timing: float = 1.0:
	set(v):
		spawn_timing = v
		if not is_node_ready():
			await ready
		spawner.timing = spawn_timing

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
		canon_collision_polygon_2d.polygon = canon_polygon_2d.polygon
		base_collision_polygon_2d.polygon = base_polygon_2d.polygon
		ray_cast_2d.queue_free()


func _on_spawner_scene_spawned(bullet):
	bullet.velocity = -spawner.global_transform.y
