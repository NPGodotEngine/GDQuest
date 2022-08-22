extends PanelContainer

onready var scores_column := $MarginContainer/VBoxContainer/ScoresColumn

func _ready():
	add_line("Athos")
	add_line("Portos")
	add_line("Aramis")
	
func add_line(player_name:String) -> void:
	var line = Label.new()
	line.text = player_name
	scores_column.add_child(line)
		
