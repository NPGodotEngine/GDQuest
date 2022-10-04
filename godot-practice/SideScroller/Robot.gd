extends KinematicBody2D

export var speed := 600.0
export var gravity := 4500.0
export var jump_strength := 1400.0

var velocity := Vector2.ZERO

func _physics_process(delta:float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_direction * speed
	velocity.y += gravity * delta
	
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	var is_jump_cancel := velocity.y < 0.0 and Input.is_action_just_released("jump")
	if is_jumping:
		velocity.y = -jump_strength
	elif is_jump_cancel:
		velocity.y = 0.0
		
	velocity = move_and_slide(velocity, Vector2.UP)
