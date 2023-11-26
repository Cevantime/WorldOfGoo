extends StateMachine

@export var JUMP_VELOCITY = 200.0
var jumping = false
@onready var jump_timer = $Timer

func _supports(node):
	return node is CharacterBody2D
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and referer.is_on_floor():
		jumping = true
		jump_timer.start()
	
	if jumping and Input.is_action_pressed("ui_accept"):
		referer.velocity.y -= JUMP_VELOCITY * 10 * delta
		


func _on_timer_timeout():
	jumping = false
