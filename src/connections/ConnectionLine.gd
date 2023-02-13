extends Line2D


onready var target_width = width

func _ready():
	appear()


func appear():
	width = 0
	var _t = get_tree().create_tween().tween_property(self, "width", target_width, 0.8)


func show():
	if ! visible:
		appear()
	.show()
