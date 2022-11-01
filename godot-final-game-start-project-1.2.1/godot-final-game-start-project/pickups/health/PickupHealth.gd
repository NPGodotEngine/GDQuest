extends Pickup

export var amount_to_heal := 5

func _on_robot_pickup(robot: Robot) -> void:
	_disable()
	robot.heal(amount_to_heal)
	_animation_player.play("destroy")
	_audio.play()
