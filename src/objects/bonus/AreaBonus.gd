extends Area2D

@onready var bonus = $Bonus

func _on_body_entered(body):
	if body.is_in_group(Groups.PLAYERS):
		bonus.grabbed_by(body)
		
func _disappear():
	queue_free()

func _on_bonus_grabbed():
	_disappear()
