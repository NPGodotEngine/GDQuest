extends PlayerState

func enter(msg:={}) -> void:
	player.velocity = Vector2.ZERO
	
func physics_update(delta:float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
		
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("ui_up"):
		state_machine.transition_to("Air", {do_jump=true})
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		state_machine.transition_to("Run")
		
