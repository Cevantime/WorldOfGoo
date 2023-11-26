@tool
extends EditorPlugin

var goo_connection_tab_packed = preload("res://addons/goo_connection/GooConnectionTab.tscn")
var goo_connection_tab

func _enter_tree():
	goo_connection_tab = goo_connection_tab_packed.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, goo_connection_tab)

func _exit_tree():
	remove_control_from_docks(goo_connection_tab)
	goo_connection_tab.queue_free()
