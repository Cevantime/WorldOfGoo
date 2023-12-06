extends "res://src/goos/visual/ConnectableGoo.gd"

@onready var connectable_state = $GooBody/Connectable
@onready var buttons = $Buttons

signal activated
signal deactivated
signal connected
signal action_assigned

var action_name
var active = false

func _ready():
	for action in ["A", "B", "X", "Y"]:
		var button = buttons.get_node("Button"+action)
		button.connect("pressed", Callable(self, "assign_action").bind(action))

func _on_draggable_limited_speed_drag_started():
	states.change_state("Drag")


func _on_draggable_limited_speed_drag_ended():
	connectable_state.request_connection()
	states.change_state("Awake")


func _on_connectable_connected(_other):
	super(_other)
	if connectable_state.neighbours.size() >=2:
		return
	
	emit_signal("connected", self)
	
func switch_to_just_connected():
	states.change_state("JustConnected")

func assign_action(action):
	action_name = "action_"+action
	emit_signal("action_assigned")
	body_states.change_state("Connected")
	states.change_state("Connected")


func _on_pisto_grabbable_pisto_grabbed(p):
	states.change_state("Drag")
	body_states.change_state("Dragged", [p.view_finder_area])


func _on_pisto_grabbable_pisto_released(_p):
	states.change_state("Awake")
	body_states.change_state("Idle")


func _on_pisto_releaseable_pisto_released(_p):
	connectable_state.request_connection()

