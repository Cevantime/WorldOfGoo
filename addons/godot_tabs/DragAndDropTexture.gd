@tool
extends TextureRect

var path
@export var object_path: NodePath

@onready var object = get_node(object_path)

func _get_drag_data(at_position):
	return { "type": "files", "files": [path], "self_index": object.get_index()}
