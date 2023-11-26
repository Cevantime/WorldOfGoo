@tool
extends PanelContainer

@export var image: String
@export var text: String
@export var path: String
@export var packed_scene: PackedScene
@export var node_path: String

@onready var label = $MarginContainer/VBoxContainer/Label
@onready var v_box_container = $MarginContainer/VBoxContainer
@onready var grid_container = $MarginContainer/GridContainer
@onready var file_line_edit = $MarginContainer/GridContainer/FileLineEdit
@onready var name_line_edit = $MarginContainer/GridContainer/NameLineEdit
@onready var image_line_edit = $MarginContainer/GridContainer/ImageLineEdit
@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect

signal add_requested(object)
signal object_edited(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	if !packed_scene and path:
		packed_scene = load(path)
	set_text(text)
	if packed_scene:
		texture_rect.path = packed_scene.resource_path

func set_text(text = ""):
	if (!text or text == "") and packed_scene:
		var resource_path = packed_scene.resource_path
		var splited = resource_path.split("/")
		splited.reverse()
		var first = splited[0]
		self.text = first.split(".")[0]
	else:
		self.text = text
		
	label.text = self.text
	
func initialize_image():
	if image and image != "":
		texture_rect.texture = load(image)
	else :
		EditorInterface.get_resource_previewer().queue_edited_resource_preview(packed_scene, self, "_on_preview_generated", {})
		
func _on_preview_generated(path: String, preview: Texture2D, thumbnail: Texture2D, userdata):
	if preview:
		texture_rect.texture = preview
	


func _on_remove_button_pressed():
	queue_free()


func _on_edit_button_pressed():
	file_line_edit.text = packed_scene.resource_path
	name_line_edit.text = text
	image_line_edit.text = image
	grid_container.show()
	v_box_container.hide()


func _get_drag_data(at_position):
	return { "type": "files", "files": [packed_scene.resource_path], "self_index" : get_index() }

func _on_close_button_pressed():
	grid_container.hide()
	v_box_container.show()


func _on_validate_object_button_pressed():
	packed_scene = load(file_line_edit.text)
	set_text(name_line_edit.text)
	image = image_line_edit.text
	initialize_image()
	grid_container.hide()
	v_box_container.show()
	emit_signal("object_edited", self)


func _on_see_button_pressed():
	EditorInterface.open_scene_from_path(packed_scene.resource_path)

