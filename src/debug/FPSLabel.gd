extends Label

func _ready():
	if OS.has_feature("release"):
		hide()
	
func _process(_delta):
	text = "FPS : %s" % Engine.get_frames_per_second()
