extends Area2D

signal pisto_hovered(pisto)
signal pisto_exited(pisto)
signal pisto_grabbed(pisto)
signal pisto_released(pisto, do_action)

func pisto_hover(pisto):
	emit_signal("pisto_hovered", pisto)
	
func pisto_exit(pisto):
	emit_signal("pisto_exited", pisto)
	
func pisto_grab(pisto):
	emit_signal("pisto_grabbed", pisto)
	
func pisto_release(pisto, do_action = true):
	emit_signal("pisto_released", pisto, do_action)
