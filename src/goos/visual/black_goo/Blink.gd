extends StateMachine

const BlackGoo = preload("res://src/goos/visual/black_goo/BlackGoo.gd")

@onready var animation_player: AnimationPlayer = referer.get_node("AnimationPlayer")
@onready var event_spawner = $RandomEventSpawner

func _supports(node):
	return node is BlackGoo
	
func _enter_state(_previous, _params = []):
	event_spawner.start()
	
func _exit_state(_next):
	event_spawner.stop()

func _on_RandomEventSpawner_event_generated():
	var anim_index = randi() % 2
	animation_player.play("blink_" + str(anim_index))
