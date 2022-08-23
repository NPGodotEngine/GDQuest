extends HBoxContainer

onready var points_label := $PointsLabel
onready var name_label := $NameLabel

func set_player_points(points:String):
	points_label.text = points.pad_zeros(6)

func set_player_name(name:String):
	name_label.text = name
