extends Node2D

export var DEFORMATION_FACTOR =2.0
export var DEFORMATION_AMPLITUDE = 0.8
export var BOUNCING_SPEED = 1.0

var deformation_vertical_influence = 0.5
var deformation = Vector2.ZERO setget set_deformation
var current_deformation = Vector2.ZERO

onready var sprite_position = $SpritePosition
onready var sprite_rotation = $SpritePosition/SpriteRotation
onready var body = $GooBody
onready var states = $States

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	sprite_position.rotation = body.contact_normal.angle() + PI / 2
	apply_deformation()
	call_deferred("set_sprite_rotation")

func set_sprite_rotation():
	sprite_rotation.global_rotation = body.global_rotation
	
func set_deformation(def):
	deformation = def
	
func apply_deformation():
	current_deformation = lerp(current_deformation, deformation, 0.5)
	var deformation_intensity = current_deformation.length()
	var deformation_factor = deformation_intensity - deformation_intensity / 2
	sprite_position.rotation = current_deformation.angle()
	sprite_position.scale = Vector2(1 + deformation_factor, 1 - deformation_factor)
	sprite_rotation.position.y = lerp(sprite_rotation.position.y, deformation_factor * 30 * deformation_vertical_influence, 0.5)
	

func _on_GooBody_drag_started():
	states.change_state("Picked")

func _on_GooBody_drag_ended():
	states.change_state("Free")
