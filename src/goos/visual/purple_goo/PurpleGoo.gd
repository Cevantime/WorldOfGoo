extends "res://src/goos/visual/ConnectableGoo.gd"

@onready var buttons = $Buttons
@onready var focusable = $Focusable

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

func _on_first_connect(_other):
	focusable.request_focus()

func assign_action(action):
	action_name = "action_"+action
	focusable.release_focus()
	change_both_state("SolidConnected")

