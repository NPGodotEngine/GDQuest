extends KinematicBody2D

const speed := 700.0

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity = direction * speed
	move_and_slide(velocity)