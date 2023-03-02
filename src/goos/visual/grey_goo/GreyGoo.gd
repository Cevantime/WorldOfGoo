extends "res://src/goos/visual/BaseGoo.gd"

onready var connectable_state = $GooBody/Connectable

func connect_to(other):
	ConnectionManager.connect_connectables(connectable_state, other.connectable_state)
