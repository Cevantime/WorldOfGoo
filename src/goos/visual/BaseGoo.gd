extends Node2D

@export_category("Deformation")
@export var DEFORMATION_FACTOR = 2.0
@export var DEFORMATION_AMPLITUDE = 0.8
@export_category("Speed")
@export var BOUNCING_SPEED = 1.0

var deformation_vertical_influence = 0.5
var deformation = Vector2.ZERO: set = set_deformation
var current_deformation = Vector2.ZERO

@onready var sprite_position = $SpritePosition
@onready var sprite_rotation = $SpritePosition/SpriteRotation
@onready var body = $GooBody
@onready var states = $States
@onready var body_states = $GooBody/States
@onready var outline = $SpritePosition/SpriteRotation/GooOutline

func _ready():
	sprite_position.rotation += rotation
	rotation = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	apply_deformation()
	call_deferred("set_sprite_rotation")

func set_sprite_rotation():
	sprite_rotation.global_rotation = body.global_rotation
	
func set_deformation(def):
	deformation = def.limit_length(DEFORMATION_AMPLITUDE)
	
func apply_deformation():
	current_deformation = lerp(current_deformation, deformation, 0.5)
	var deformation_factor = current_deformation.length() / 2
	sprite_position.scale = Vector2(1 + deformation_factor, 1 - deformation_factor)
	sprite_position.rotation = current_deformation.angle()
	sprite_rotation.position.y = lerp(sprite_rotation.position.y, deformation_factor * 30 * deformation_vertical_influence, 0.5)
	


func _on_can_be_awaken_is_awaken():
	states.change_state("Awake")
