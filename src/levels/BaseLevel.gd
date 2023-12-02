extends Node2D

@export var next_level = "Level1"

var goo_packed = preload("res://src/goos/visual/black_goo/BlackGoo.tscn")
var player_cam
var draggable_cam

@onready var main_camera = $Camera2D

func _ready():
	for cl in get_tree().get_nodes_in_group(Groups.CONNECTION_LINES):
		var g1 = cl.goo_a
		var g2 = cl.goo_b
		connect_goos(g1, g2)
		cl.queue_free()

func connect_goos(goo1, goo2):
	ConnectionManager.connect_goos(goo1, goo2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("spawn_goo"):
		var goo = goo_packed.instantiate()
		goo.global_position = get_global_mouse_position()
		get_tree().current_scene.add_child(goo)

		
func _on_button_pressed():
	get_tree().reload_current_scene()


func _on_win_area_player_won():
	$UI/WinPanel.show()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://src/levels/"+next_level+".tscn")
