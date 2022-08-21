extends Sprite

var boost_speed := 1500.0
var normal_speed := 600.0
var max_speed := normal_speed
var velocity := Vector2.ZERO
var drag_factor := 0.1

func _process(delta):
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	# to fix moving faster at diagonal, normalize
	# direction
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()
	
	# we dont update velocity but only after
	# we find steering vector	
#	velocity = direction * max_speed
	
	var desired_velocity := direction * max_speed
	var steering_velocity := desired_velocity - velocity
	velocity += steering_velocity * drag_factor
	
	position += velocity * delta
	
	if direction:
		rotation = velocity.angle()


func _on_Timer_timeout():
	max_speed = normal_speed
