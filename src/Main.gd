extends Node2D


var goo_packed = preload("res://src/goos/visual/black_goo/BlackGoo.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
#	$Goos/GreyGoo.connect_to($Goos/GreyGoo2)
#	$Goos/GreyGoo2.connect_to($Goos/GreyGoo3)
#	$Goos/GreyGoo3.connect_to($Goos/GreyGoo4)
	connect_goos($Goos/BlackGoo5, $Goos/BlackGoo6)
	connect_goos($Goos/BlackGoo5, $Goos/BlackGoo7)
	connect_goos($Goos/BlackGoo6, $Goos/BlackGoo7)
	connect_goos($Goos/BlackGoo7, $Goos/BlackGoo8)
	connect_goos($Goos/BlackGoo8, $Goos/BlackGoo9)
	connect_goos($Goos/BlackGoo9, $Goos/BlackGoo10)
	connect_goos($Goos/BlackGoo8, $Goos/BlackGoo10)
	pass

func connect_goos(goo1, goo2):
	ConnectionManager.connect_goos(goo1, goo2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("spawn_goo"):
		var goo = goo_packed.instantiate()
		goo.global_position = get_global_mouse_position()
		get_tree().get_root().add_child(goo)
