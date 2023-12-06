extends Label


func _ready():
	if OS.has_feature("release"):
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Connectable count : " + str(get_tree().get_nodes_in_group(Groups.CONNECTABLE_STATE).size())
