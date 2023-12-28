extends Node2D

@onready var line_2d = $Line2D
@onready var bodies = $Bodies
@onready var ref = $Bodies/Segment1/Ref
@onready var ref_2 = $Bodies/Segment2/Ref
@onready var ref_3 = $Bodies/Segment3/Ref
@onready var ref_4 = $Bodies/Segment4/Ref
@onready var ref_5 = $Bodies/Segment4/Ref2
@onready var segment_4 = $Bodies/Segment4
@onready var refs = [ref, ref_2, ref_3, ref_4, ref_5]

func set_line_2d():
	line_2d.clear_points()
	for b in refs:
		line_2d.add_point(line_2d.to_local(b.global_position))

func _process(_delta):
	set_line_2d()


func _on_area_2d_body_entered(body):
	if body.is_in_group(Groups.PLAYERS):
		body.emit_signal("rope_visited", segment_4)
