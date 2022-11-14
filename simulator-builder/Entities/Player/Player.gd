extends KinematicBody2D

export var movement_speed := 200.0

func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	
	move_and_slide(direction * movement_speed)
