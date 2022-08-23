extends Control

onready var scoreboard := $Scoreboard
onready var name_field := $HBoxContainer/NameField
onready var points_field := $HBoxContainer/PointsField

func _on_OkButton_pressed():
	if not name_field.text or not points_field.text:
		return
		
	scoreboard.add_line(name_field.text, points_field.text)
	scoreboard.show()
	name_field.text = ""
	points_field.text = ""
	
