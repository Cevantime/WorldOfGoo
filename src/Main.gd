extends Node2D


var goo_packed = preload("res://src/goos/visual/black_goo/BlackGoo.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$GreyGoo.connect_to($GreyGoo2)
	$GreyGoo2.connect_to($GreyGoo3)
	$GreyGoo3.connect_to($GreyGoo4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("spawn_goo"):
		var goo = goo_packed.instance()
		goo.global_position = get_global_mouse_position()
		get_tree().get_root().add_child(goo)
