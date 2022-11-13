extends PlayerState

export var sprint_speed := 800.0
	
func enter(msg:={}) -> void:
	player.speed = sprint_speed
	
func physics_update(delta:float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
		
	var input_direction_x = Input.get_axis("ui_left", "ui_right")	
	
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump=true})
	elif Input.is_action_just_released("sprint"):
		state_machine.transition_to("Run")
	elif is_equal_approx(player.velocity.x, 0.0):
		state_machine.transition_to("Idle")
		
	
