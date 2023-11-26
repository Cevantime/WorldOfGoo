@tool
extends GridContainer

signal closed()
signal validated()

func _on_close_button_pressed():
	emit_signal("closed")


func _on_validate_object_button_pressed():
	emit_signal("validated")

