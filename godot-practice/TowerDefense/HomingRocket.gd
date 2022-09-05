extends "common/Rocket.gd"

var velocity := Vector2.ZERO
export (float, 0.01, 1.0) var drag_factor := 0.05
var target: PhysicsBody2D = null

func _move(delta:float):
	if not target or not is_instance_valid(target):
		explode()
		return
	
	var direction := global_position.direction_to(target.global_position)
	direction = direction.normalized()
	var desired_velocity := direction * speed
	var steering_velocity := desired_velocity - velocity
	velocity += steering_velocity * drag_factor
	position += velocity * delta
	rotation = velocity.angle()
	
func set_initial_velocity():
	velocity = transform.x * speed
