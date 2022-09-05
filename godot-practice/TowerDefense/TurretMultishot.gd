extends "Turret.gd"

func _on_Timer_timeout():
	for target in target_list:
		var rocket: Area2D = preload("common/Rocket.tscn").instance()
		add_child(rocket)
		var target_angle: float = target.global_position.angle_to_point(cannon.global_position)
		rocket.rotation = target_angle
		rocket.global_position = cannon.global_position
		
	
func _rotate_to_target():
	var target_angle: float = PI / 2.0
	if target_list:
		var average_point := Vector2.ZERO
		for target in target_list:
			average_point += target.global_position
		
		average_point /= target_list.size()
		target_angle = average_point.angle_to_point(global_position)
		sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)
