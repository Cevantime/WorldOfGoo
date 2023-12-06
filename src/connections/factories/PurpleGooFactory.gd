@tool
extends "res://src/connections/factories/BaseFactory.gd"

func supports(c1, c2):
	var ref1 = c1.referer.get_parent()
	var ref2 = c2.referer.get_parent()
	return (ref1.is_in_group(Groups.PURPLE_GOOS) or ref2.is_in_group(Groups.PURPLE_GOOS)) \
		and ((ref1.is_in_group(Groups.RED_GOOS) or ref1.is_in_group(Groups.GREEN_GOOS)) \
		or (ref2.is_in_group(Groups.RED_GOOS) or ref2.is_in_group(Groups.GREEN_GOOS)))

func _create_default_connection_line(c1, c2):
	var line = super._create_default_connection_line(c1, c2)
	line.backwards = c2.referer.goo.is_in_group(Groups.PURPLE_GOOS)
	return line
