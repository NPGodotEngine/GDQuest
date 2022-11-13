class_name Player
extends KinematicBody2D

export var speed := 100.0
export var gravity := 1400.0
export var jump_impluse := 2500.0

onready var state_machine := $StateMachine

var velocity := Vector2.ZERO

func _ready() -> void:
	state_machine.connect("state_transitioned", self, "_on_StateMachine_state_transitioned")
	
func _on_StateMachine_state_transitioned(state_name) -> void:
	print(state_name)	
