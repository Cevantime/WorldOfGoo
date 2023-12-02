extends Area2D

@onready var view_finder_area = $ViewFinderArea
@onready var states = $States
@onready var shape = $CollisionShape2D.shape

@export var VIEW_FINDER_SPEED := 100.0

func enable():
	states.change_state("Enabled")
	
func disable():
	states.change_state("Disabled")
