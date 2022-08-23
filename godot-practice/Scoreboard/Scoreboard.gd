extends PanelContainer

onready var scores_column := $MarginContainer/VBoxContainer/ScoresColumn

var player_scores := {
	"Athos": 1000,
	"Portos": 299,
	"Aramis": 90
} 
func _ready():
	for name in player_scores:
		add_line(name, str(player_scores[name]))
		
func add_line(player_name:String, player_points:String) -> void:
	var line := preload("ScoreLine.tscn").instance()
	scores_column.add_child(line)
	line.set_player_name(player_name)
	line.set_player_points(player_points)
	player_scores[player_name] = player_points	


func _on_HideButton_pressed():
	hide()
