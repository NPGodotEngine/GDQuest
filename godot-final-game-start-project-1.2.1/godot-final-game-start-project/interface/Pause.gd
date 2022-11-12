# The pause screen. It should exist in the main game scene but start hidden.
#
# Pressing the "pause" input action will show this screen and pause everything
# else.
extends Control

onready var _button_continue := $CenterContainer/VBoxContainer/ContinueButton
onready var _button_restart := $CenterContainer/VBoxContainer/RestartButton
onready var _button_quit := $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void :
	# make sure pause menu is processing while game pausing
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	
	_button_quit.connect("pressed", self, "_on_Button_quit_pressed")
	_button_continue.connect("pressed", self, "_on_Button_continue_pressed")
	_button_restart.connect("pressed", self, "_on_Button_restart_pressed")
	
	Events.connect("resume_game", self, "_on_Event_resume_game")
	Events.connect("pause_game", self, "_on_Envent_pause_game")
	Events.connect("restart_game", self, "_on_Event_restart_game")
	Events.connect("quit_game", self, "_on_Event_quit_game")
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause_toggle"):
		if get_tree().paused:
			Events.emit_signal("resume_game")
		else:
			Events.emit_signal("pause_game")
		get_tree().set_input_as_handled()
		
func _on_Button_quit_pressed() -> void:
	Events.emit_signal("quit_game")

func _on_Button_continue_pressed() -> void:
	Events.emit_signal("resume_game")
	
func _on_Button_restart_pressed() -> void:
	Events.emit_signal("restart_game")
	
func _on_Event_resume_game() -> void:
	self.hide()
	
func _on_Envent_pause_game() -> void:
	self.show()

func _on_Event_restart_game() -> void:
	self.hide()

func _on_Event_quit_game() -> void:
	self.hide()
	
