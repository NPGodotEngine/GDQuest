## Takes care of showing the UI. Should be always present. Uses the global Events
## autoload to know when to update
extends Control

var _score := 0 setget _set_score

onready var health_bar := $HealthBar
onready var score_label := $ScoreLabel

func _ready() -> void:
	_score = 0
	Events.connect("mob_died", self, "_on_Event_mob_die")
	Events.connect("player_health_changed", self, "_on_Event_player_health_changed")

func _on_Event_mob_die(mob_points) -> void:
	_set_score(_score + mob_points)

func _on_Event_player_health_changed(new_health) -> void:
	health_bar.health = new_health
	
func _set_score(score) -> void:
	_score = score
	score_label.text = str(_score)
