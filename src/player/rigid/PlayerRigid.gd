extends RigidBody2D

signal _forces_integrated
signal bonus_grabbed(node)
signal rope_visited(rope)

@onready var pisto_area = $PistoArea

func _integrate_forces(state: PhysicsDirectBodyState2D):
	emit_signal("_forces_integrated", state)

func grab_bonus(bonus: Node):
	emit_signal("bonus_grabbed", bonus)
