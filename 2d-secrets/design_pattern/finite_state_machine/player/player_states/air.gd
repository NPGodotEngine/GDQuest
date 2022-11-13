extends PlayerState

func enter(msg:={}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.jump_impluse
		
func physics_update(delta:float) -> void:
	var input_direction_x = Input.get_axis("ui_left", "ui_right")
	
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
