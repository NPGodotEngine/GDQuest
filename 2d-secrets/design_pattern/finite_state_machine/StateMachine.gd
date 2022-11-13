class_name StateMachine
extends Node

signal state_transitioned(state_name)

export var initial_state := NodePath()

onready var state: State = get_node(initial_state)
	
func _ready() -> void:
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	
	state.enter()

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)
	
func transition_to(state_name:String, msg:={}) -> void:
	assert(has_node(state_name), "%s state machine has not child state node name %s" % [self.name, state_name])
	
	state.exit()
	state = get_node(state_name)
	state.enter(msg)
	
	emit_signal("state_transitioned", state.name)
	
	

