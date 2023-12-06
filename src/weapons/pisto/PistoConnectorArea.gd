@tool
extends Area2D

@onready var view_finder_area = $ViewFinderArea
@onready var pisto_area = $PistoArea
@onready var states = $States
@onready var collision_shape_2d = $CollisionShape2D
@onready var original_texture_radius = pisto_area.get_rect().size.x / 2
@onready var shape_radius = collision_shape_2d.shape.radius

@export var VIEW_FINDER_SPEED := 100.0
	
func enable():
	states.change_state("Enabled")
	
func disable():
	states.change_state("Disabled")
	
func grow_by_factor(factor):
	var new_shape = collision_shape_2d.shape.duplicate()
	new_shape.radius *= factor
	call_deferred("change_shape", new_shape)
	enable()

func change_shape(shape):
	collision_shape_2d.shape = shape
	
func _process(_delta):
	if collision_shape_2d.shape.radius != shape_radius:
		shape_radius = collision_shape_2d.shape.radius
		resize_pisto_area()

func resize_pisto_area():
	var new_scale = shape_radius / original_texture_radius
	pisto_area.scale = Vector2(new_scale, new_scale)
		
func _on_pisto_area_texture_changed():
	original_texture_radius = pisto_area.get_rect().size.x / 2
	resize_pisto_area()


