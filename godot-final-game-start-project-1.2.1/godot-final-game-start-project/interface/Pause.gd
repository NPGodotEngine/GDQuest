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
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause_toggle"):
		if get_tree().paused:
			get_tree().paused = false
			self.hide()
		else:
			get_tree().paused = true
			self.show()
		get_tree().set_input_as_handled()
		
func _on_Button_quit_pressed() -> void:
	get_tree().quit()

func _on_Button_continue_pressed() -> void:
	get_tree().paused = false
	self.hide()
	
func _on_Button_restart_pressed() -> void:
	get_tree().paused = false
	self.hide()
	get_tree().reload_current_scene()
	
