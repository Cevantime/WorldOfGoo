extends "res://src/goos/visual/BaseGoo.gd"

@onready var connectable_state = $GooBody/Connectable
@onready var blast = $SpritePosition/SpriteRotation/Blast
@onready var draggable_states = $GooBody/States/Idle/DraggableLimitedSpeed
@onready var air_arrow = $SpritePosition/SpriteRotation/AirArrow

signal connected(goo)
signal direction_set

func _ready():
	blast.material = blast.material.duplicate()

func _on_draggable_drag_ended():
	connectable_state.request_connection()


func _on_connectable_connection_refused():
	states.change_state("Free")


func _on_connectable_connected(_other):
	if connectable_state.neighbours.size() >=2:
		return
	emit_signal("connected", self)

func switch_to_just_connected():
	air_arrow.show()
	body_states.change_state("JustConnected")
	states.change_state("JustConnected")

func _on_set_direction_direction_set():
	emit_signal("direction_set")

func switch_to_started():
	air_arrow.hide()
	body_states.change_state("Started")
	states.change_state("Started")

func _on_connectable_disconnected(_other):
	if connectable_state.neighbours.size() == 0:
		body_states.change_state("Idle")
		draggable_states.change_state("Dragged")



func _on_draggable_limited_speed_drag_started():
	states.change_state("Dragged")
