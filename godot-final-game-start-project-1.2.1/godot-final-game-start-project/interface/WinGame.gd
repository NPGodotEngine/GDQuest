extends Control

onready var _button_restart := $CenterContainer/VBoxContainer/RestartButton
onready var _button_quit := $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	_button_restart.connect("pressed", self, "_on_Button_restart_pressed")
	_button_quit.connect("pressed", self, "_on_Button_quit_pressed")
	
	Events.connect("restart_game", self, "_on_Event_restart_game")
	Events.connect("quit_game", self, "_on_Event_quit_game")

func _on_Button_restart_pressed() -> void :
	Events.emit_signal("restart_game")
	self.hide()
	
func _on_Button_quit_pressed() -> void:
	Events.emit_signal("quit_game")
	self.hide()
	
func _on_Event_restart_game() -> void:
	get_tree().change_scene("res://rooms/Main.tscn")

func _on_Event_quit_game() -> void:
	get_tree().quit()

	
