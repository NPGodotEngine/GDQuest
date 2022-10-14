extends KinematicBody2D

export var speed := 450.0
export var drag_factor := 0.1

var velocity := Vector2.ZERO
var target: KinematicBody2D

onready var aggro_area := $AggroArea

func _ready() -> void:
	aggro_area.connect("body_entered", self, "_on_player_entered") 
	aggro_area.connect("body_exited", self, "_on_player_exited")

func _physics_process(delta:float) -> void:
	var direction := Vector2.UP

	if target:
		direction = to_local(target.global_position).normalized()
		
	
	var desired_velocity := speed * direction
	var steering_vector := desired_velocity - velocity
	
	velocity += steering_vector * drag_factor
	velocity = move_and_slide(velocity, Vector2.DOWN)
	
func _on_player_entered(robot: KinematicBody2D) -> void:
	target = robot

func _on_player_exited(robot: KinematicBody2D) -> void:
	target = null
